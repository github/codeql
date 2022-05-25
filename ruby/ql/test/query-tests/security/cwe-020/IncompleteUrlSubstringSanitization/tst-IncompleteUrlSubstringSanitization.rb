def test (x)
    x.index("internal") != nil; # NOT OK, but not flagged
    x.index("localhost") != nil; # NOT OK, but not flagged
    x.index("secure.com") != nil; # NOT OK
    x.index("secure.net") != nil; # NOT OK
    x.index(".secure.com") != nil; # NOT OK
    x.index("sub.secure.") != nil; # NOT OK, but not flagged
    x.index(".sub.secure.") != nil; # NOT OK, but not flagged

    x.index("secure.com") === nil; # NOT OK
    x.index("secure.com") === 0; # NOT OK
    x.index("secure.com") >= 0; # NOT OK

    x.start_with?("https://secure.com"); # NOT OK
    x.end_with?("secure.com"); # NOT OK
    x.end_with?(".secure.com"); # OK
    x.start_with?("secure.com/"); # OK
    x.index("secure.com/") === 0; # OK

    x.include?("secure.com"); # NOT OK

    x.index("#") != nil; # OK
    x.index(":") != nil; # OK
    x.index(":/") != nil; # OK
    x.index("://") != nil; # OK
    x.index("//") != nil; # OK
    x.index(":443") != nil; # OK
    x.index("/some/path/") != nil; # OK
    x.index("some/path") != nil; # OK
    x.index("/index.html") != nil; # OK
    x.index(":template:") != nil; # OK
    x.index("https://secure.com") != nil; # NOT OK
    x.index("https://secure.com:443") != nil; # NOT OK
    x.index("https://secure.com/") != nil; # NOT OK

    x.index(".cn") != nil; # NOT OK, but not flagged
    x.index(".jpg") != nil; # OK
    x.index("index.html") != nil; # OK
    x.index("index.js") != nil; # OK
    x.index("index.php") != nil; # OK
    x.index("index.css") != nil; # OK

    x.index("secure=true") != nil; # OK (query param)
    x.index("&auth=") != nil; # OK (query param)

    x.index(getCurrentDomain()) != nil; # NOT OK, but not flagged
    x.index(location.origin) != nil; # NOT OK, but not flagged

	x.index("tar.gz") + offset; # OK
	x.index("tar.gz") - offset; # OK

    x.index("https://example.internal") != nil; # NOT OK
    x.index("https://") != nil; # OK

    x.start_with?("https://example.internal"); # NOT OK
    x.index('https://example.internal.org') != 0; # NOT OK
    x.index('https://example.internal.org') === 0; # NOT OK
    x.end_with?("internal.com"); # NOT OK
    x.start_with?("https://example.internal:80"); # OK

	x.index("secure.com") != nil; # NOT OK
	x.index("secure.com") === nil; # OK
	!(x.index("secure.com") != nil); # OK
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
