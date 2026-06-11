def foo
	/^http:\/\/example.com/; # OK
	/^http:\/\/test.example.com/; # $ Alert // NOT OK
	/^http:\/\/test\.example.com/; # OK
	/^http:\/\/test.example.net/; # $ Alert // NOT OK
	/^http:\/\/test.(example-a|example-b).com/; # $ Alert // NOT OK
	/^http:\/\/(.+).example.com\//; # $ Alert // NOT OK
	/^http:\/\/(\.+)\.example.com/; # OK
	/^http:\/\/(?:.+)\.test\.example.com\//; # $ Alert // NOT OK
	/^http:\/\/test.example.com\/(?:.*)/; # $ Alert // OK
	Regexp.new("^http://test.example.com"); # $ Alert // NOT OK
	if (s.match("^http://test.example.com")); end # $ Alert // NOT OK


	Regexp.new(id(id(id("^http://test.example.com")))); # $ Alert // NOT OK

	Regexp.new(`test.example.com$`); # $ Alert // NOT OK

	hostname = '^test.example.com'; # $ Alert // NOT OK
	Regexp.new("#{hostname}$"); # $ Alert

	domain = { hostname: 'test.example.com$' }; # $ Alert // NOT OK
	Regexp.new(domain[:hostname]);




	convert1({ hostname: 'test.example.com$' }); # $ Alert // NOT OK

	domains = [ { hostname: 'test.example.com$' } ];  # NOT OK - but not flagged due to limitations of TypeTracking.



	domains.map{ |d| convert2(d) };

	/^(.+\.(?:example-a|example-b)\.com)\//; # NOT OK
	/^(https?:)?\/\/((service|www).)?example.com(?=$|\/)/; # $ Alert // NOT OK
	/^(http|https):\/\/www.example.com\/p\/f\//; # $ Alert // NOT OK
	/^(http:\/\/sub.example.com\/)/i; # $ Alert // NOT OK
	/^https?:\/\/api.example.com/; # $ Alert // NOT OK
	Regexp.new('^http://localhost:8000|' + "^https?://.+\\.example\\.com/"); # $ Alert // NOT OK
	Regexp.new("^http[s]?:\/\/?sub1\\.sub2\\.example\\.com\/f\/(.+)"); # NOT OK
	/^https:\/\/[a-z]*.example.com$/; # $ Alert // NOT OK
	Regexp.compile('^protos?://(localhost|.+.example.net|.+.example-a.com|.+.example-b.com|.+.example.internal)'); # $ Alert // NOT OK

	/^(example.dev|example.com)/; # OK

	Regexp.new('^http://localhost:8000|' + "^https?://.+.example\\.com/"); # $ Alert // NOT OK

	primary = 'example.com$';
	Regexp.new('test.' + primary); # NOT OK, but not detected

	Regexp.new('test.' + 'example.com$'); # NOT OK

	Regexp.new('^http://test\.example.com'); # NOT OK

	/^http:\/\/(..|...)\.example\.com\/index\.html/; # OK, wildcards are intentional
	/^http:\/\/.\.example\.com\/index\.html/; # OK, the wildcard is intentional
	/^(foo.example\.com|whatever)$/; # $ Alert // kinda OK - one disjunction doesn't even look like a hostname
end
def id(e); return e; end
def convert1(domain)
	return Regexp.new(domain[:hostname]);
end
def convert2(domain)
	return Regexp.new(domain[:hostname]);
end

class A
	def self.match?(x) = true
end

A.match?("^http://test.example.com") # OK

class B
	def self.match?(x)
		some_string.match?(x)
	end
end

B.match?("^http://test.example.com") # $ Alert // NOT OK
