class CreateApiKeys < ActiveRecord::Migration
  def change
	create_table :api_keys do |t|
		t.string :key, :null => false
		t.string :regex_str

		t.boolean :can_read, :default => true, :null => false
		t.boolean :can_publish, :default => false, :null => false
		t.boolean :can_delete, :default => false, :null => false
	end
  end
end
