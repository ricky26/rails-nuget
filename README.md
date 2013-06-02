# rails-nuget

rails-nuget is a Ruby on Rails project that provides a Nuget feed.

## Installation

Clone this repository somewhere:
```
git clone git@github.com:ricky26/rails-nuget.git nuget
```

Change the API key, look for this in app/controllers/packages_controller.rb:
```
key == "supersecret"
```
And replace with a key of your own:
```
key == "my_api_key"
```

Install dependencies:
```
bundle install
```

Start the rails server:
```
rails server
```

I've tested rails-nuget with passenger and WEBrick.

## Usage

Once you're running the server, you can point your Nuget package manager at `/api/v2/`. For example, `http://localhost:3000/api/v2/` if you're just using `rails server`.

### Adding/Removing packages

#### On the filesystem

Packages are indexed from the public/Packages directory. Any .nupkg you add or remove from there will be indexed within 30 seconds.

#### With NuGet

You can upload packages with the nuget command-line utilities.

First, you need to set your API key.
```
nuget setApiKey my_api_key -Source http://localhost:3000/api/v2/
```

##### Uploading

To upload a package, you use `nuget push` with the nupkg:
```
nuget push my_awesome_package.1.0.nupkg -Source http://localhost:3000/api/v2/
```

##### Deleting Packages

To delete a package, use the `nuget delete` command, (this requires the package name and version):
```
nuget delete my_awesome_package 1.0 -Source http://localhost:3000/api/v2/
```

## Copyright Notice

Copyright (c) 2013, Richard Ian Taylor
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

