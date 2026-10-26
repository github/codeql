# Calls to `gem` etc. outside of the Gemfile should be ignored, since they may not be configuring dependencies.

gem "foo", git: "http://foo.com"
git_source :a { |x| "http://foo.com" }
source "http://foo.com"
