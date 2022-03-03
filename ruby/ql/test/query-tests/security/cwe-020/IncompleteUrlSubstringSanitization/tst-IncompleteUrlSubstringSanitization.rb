def test (x)
    x.index("internal") != -1; # NOT OK, but not flagged
    x.index("localhost") != -1; # NOT OK, but not flagged
    x.index("secure.com") != -1; # NOT OK
    x.index("secure.net") != -1; # NOT OK
    x.index(".secure.com") != -1; # NOT OK
    x.index("sub.secure.") != -1; # NOT OK, but not flagged
    x.index(".sub.secure.") != -1; # NOT OK, but not flagged

    x.index("secure.com") === -1; # NOT OK
    x.index("secure.com") === 0; # NOT OK
    x.index("secure.com") >= 0; # NOT OK

    x.start_with?("https://secure.com"); # NOT OK
    x.end_with?("secure.com"); # NOT OK
    x.end_with?(".secure.com"); # OK
    x.start_with?("secure.com/"); # OK
    x.index("secure.com/") === 0; # OK

    x.include?("secure.com"); # NOT OK

    x.index("#") != -1; # OK
    x.index(":") != -1; # OK
    x.index(":/") != -1; # OK
    x.index("://") != -1; # OK
    x.index("//") != -1; # OK
    x.index(":443") != -1; # OK
    x.index("/some/path/") != -1; # OK
    x.index("some/path") != -1; # OK
    x.index("/index.html") != -1; # OK
    x.index(":template:") != -1; # OK
    x.index("https://secure.com") != -1; # NOT OK
    x.index("https://secure.com:443") != -1; # NOT OK
    x.index("https://secure.com/") != -1; # NOT OK

    x.index(".cn") != -1; # NOT OK, but not flagged
    x.index(".jpg") != -1; # OK
    x.index("index.html") != -1; # OK
    x.index("index.js") != -1; # OK
    x.index("index.php") != -1; # OK
    x.index("index.css") != -1; # OK

    x.index("secure=true") != -1; # OK (query param)
    x.index("&auth=") != -1; # OK (query param)

    x.index(getCurrentDomain()) != -1; # NOT OK, but not flagged
    x.index(location.origin) != -1; # NOT OK, but not flagged

	x.index("tar.gz") + offset; # OK
	x.index("tar.gz") - offset; # OK

    x.index("https://example.internal") != -1; # NOT OK
    x.index("https://") != -1; # OK

    x.start_with?("https://example.internal"); # NOT OK
    x.index('https://example.internal.org') != 0; # NOT OK
    x.index('https://example.internal.org') === 0; # NOT OK
    x.end_with?("internal.com"); # NOT OK
    x.start_with?("https://example.internal:80"); # OK

	x.index("secure.com") != -1; # NOT OK
	x.index("secure.com") === -1; # OK
	!(x.index("secure.com") != -1); # OK
	!x.include?("secure.com"); # OK

	if !x.include?("secure.com") # NOT OK

	else
		doSomeThingWithTrustedURL(x);
    end
    
    x.start_with?("https://secure.com/foo/bar"); # OK - a forward slash after the domain makes prefix checks safe.
    x.index("https://secure.com/foo/bar") >= 0 # NOT OK - the url can be anywhere in the string.
    x.index("https://secure.com") >= 0 # NOT OK
    x.index("https://secure.com/foo/bar-baz") >= 0 # NOT OK - the url can be anywhere in the string.
end
