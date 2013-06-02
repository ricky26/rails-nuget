require 'parslet'

module ODataHelper
	class CommonExprLex < Parslet::Parser
		rule(:spaces) { match('[\s\t]').repeat(1) }
		rule(:spaces?) { spaces.maybe }
	 
		rule(:comma) { spaces? >> str(',') >> spaces? }
		rule(:digit) { match('[0-9]') }

		rule(:lparen) { str('(') >> spaces? }
		rule(:rparen) { str(')') >> spaces? }

		rule(:number) {
		  (
			str('-').maybe >> (
			  str('0') | (match('[1-9]') >> digit.repeat)
			) >> (
			  str('.') >> digit.repeat(1)
			).maybe >> (
			  match('[eE]') >> (str('+') | str('-')).maybe >> digit.repeat(1)
			).maybe
		  ).as(:number) >> spaces?
		}
	 
		rule(:string) {
		  str('\'') >> (
			str('\\') >> any | str('\'').absent? >> any
		  ).repeat.as(:string) >> str('\'') >> spaces?
		}

		rule(:identifier) { (match("[A-Za-z_]") >> match("[A-Za-z0-9_]").repeat).as(:ident) >> spaces? }
		rule(:value) { string | number | identifier }

		rule(:brackets) { str('(') >> spaces? >> (rvalue >> spaces? >> (str(',') >> spaces? >> rvalue >> spaces?).repeat).maybe.as(:expression) >> str(')') >> spaces? }
		rule(:funcall) { identifier.as(:funcall) >> brackets }

		rule(:operator) { (
			str('eq')

			).as(:operator) >> spaces?
		}

		rule(:lvalue) { funcall | value }
		rule(:rvalue) { lvalue.as(:left) >> (operator.as(:op) >> rvalue.as(:right)).maybe  }

		rule(:statement) { rvalue }
		root(:statement)
	end

	class CommonExprParse < Parslet::Transform
		rule(:ident => 'true')				{ true }
		rule(:ident => 'false')				{ false }
		rule(:ident => simple(:x))			{ x.to_sym }
		rule(:number => simple(:nb))		{ nb.match(/[eE\.]/) ? Float(nb) : Integer(nb) }
		rule(:string => simple(:st))		{ st.to_s }
		rule(:operator => simple(:op))		{ op.to_sym }

		rule(:funcall => simple(:fun),
			 :expression => sequence(:args)) { pars.odata_call obj, fun, args }
		rule(:funcall => simple(:fun),
			 :expression => simple(:args)) { pars.odata_call obj, fun, [args] }
		rule(:funcall => simple(:fun))		{ pars.odata_call obj, fun, [] }
		rule(:left => simple(:left),
			 :op => simple(:op),
			 :right => simple(:right))		{ pars.odata_call obj, op, [left, right] }
		rule(:left => simple(:left))		{ left }

		def odata_call obj, meth, args=[]
			args = args.map do |x|
				case x
					when Symbol
						obj.send :odata_prop, x
					else
						x
				end
			end
			
			OData.send meth, *args
		end
	end

	module OData
		class << self
			def eq a, b
				a == b
			end

			def tolower a
				a && a.downcase
			end
		end
	end

	def self.query source, str
		lex = CommonExprLex.new
		parse = CommonExprParse.new

		parse.apply(lex.parse(str), :obj => source, :pars => parse)
	end
end
