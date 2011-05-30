Argon 
=============

Argon is (going to be) a very simple to use json builder / templating language, akin to markaby, and the other entirely ruby based
templating solutions of yesteryear.  This version is working in that it produces output, but is VERY VERY alpha,
and none of the work has been done yet to integrate it with rails, or any other framework for that matter.
I have simply always liked markaby, a coworker of mine came up with rabl to make composing JSON responses simpler,
but I wanted to develop a syntax that required less than 5 minutes to learn ENTIRELY, and that could provide just about
any json structure you want.  I'm still working on a couple of those goals, but the demos included should be enough to get you started.

(Oh - I also be renaming this project to something WAY cooler.  Inbox me with any ideas.)


Installation
-------------------------------

Right now this doesn't even need to be packaged as a gem (ok ok, I will in a few days).  The entire library is 82 lines of code as of 5/23/2011.

1) Clone the repository

    git clone git@github.com:justinvt/argo.git

2) CD into directory

    cd argo

3) Run an example

    ruby examples/object_test.rb

    # OR

    ruby examples/randomness.rb



Usage
-------------------------------

This will be changing quite a bit in the near future, but the basic idea is that you pick the object you want to express as json (lets call it @user) and do something like this...

```
@user.argon do |user|

  user.attributes :friends_count, :inbox_count, :karma-esque-thing

  stats do
  
    first_name { user.first_name }
    last_name  { user.last_name  }
    birthday   { user.birthday   }

  end


end

puts @user.to_format(true) # I know this is sloppy right now!

```

This should output the following json:

```
{
	friends_count: 123,
	inbox_count: 3343,
	karma-esque-thing: 4192
	
	stats: {
		first_name: Justin,
		last_name: Junior,
		birthday: "Whenever bro"
	}
	
}
```