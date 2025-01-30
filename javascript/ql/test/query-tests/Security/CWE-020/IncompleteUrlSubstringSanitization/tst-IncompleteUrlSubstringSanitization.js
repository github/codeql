(function(x){
    x.indexOf("internal") !== -1; // $ MISSING: Alert
    x.indexOf("localhost") !== -1; // $ MISSING: Alert
    x.indexOf("secure.com") !== -1; // $ Alert
    x.indexOf("secure.net") !== -1; // $ Alert
    x.indexOf(".secure.com") !== -1; // $ Alert
    x.indexOf("sub.secure.") !== -1; // $ MISSING: Alert
    x.indexOf(".sub.secure.") !== -1; // $ MISSING: Alert

    x.indexOf("secure.com") === -1; // $ Alert
    x.indexOf("secure.com") === 0; // $ Alert
    x.indexOf("secure.com") >= 0; // $ Alert

    x.startsWith("https://secure.com"); // $ Alert
    x.endsWith("secure.com"); // $ Alert
    x.endsWith(".secure.com");
    x.startsWith("secure.com/");
    x.indexOf("secure.com/") === 0;

    x.includes("secure.com"); // $ Alert

    x.indexOf("#") !== -1;
    x.indexOf(":") !== -1;
    x.indexOf(":/") !== -1;
    x.indexOf("://") !== -1;
    x.indexOf("//") !== -1;
    x.indexOf(":443") !== -1;
    x.indexOf("/some/path/") !== -1;
    x.indexOf("some/path") !== -1;
    x.indexOf("/index.html") !== -1;
    x.indexOf(":template:") !== -1;
    x.indexOf("https://secure.com") !== -1; // $ Alert
    x.indexOf("https://secure.com:443") !== -1; // $ Alert
    x.indexOf("https://secure.com/") !== -1; // $ Alert

    x.indexOf(".cn") !== -1; // $ MISSING: Alert
    x.indexOf(".jpg") !== -1;
    x.indexOf("index.html") !== -1;
    x.indexOf("index.js") !== -1;
    x.indexOf("index.php") !== -1;
    x.indexOf("index.css") !== -1;

    x.indexOf("secure=true") !== -1; // OK (query param)
    x.indexOf("&auth=") !== -1; // OK (query param)

    x.indexOf(getCurrentDomain()) !== -1; // $ MISSING: Alert
    x.indexOf(location.origin) !== -1; // $ MISSING: Alert

	x.indexOf("tar.gz") + offset;
	x.indexOf("tar.gz") - offset;

    x.indexOf("https://example.internal") !== -1; // $ Alert
    x.indexOf("https://") !== -1;

    x.startsWith("https://example.internal"); // $ Alert
    x.indexOf('https://example.internal.org') !== 0; // $ Alert
    x.indexOf('https://example.internal.org') === 0; // $ Alert
    x.endsWith("internal.com"); // $ Alert
    x.startsWith("https://example.internal:80");

	x.indexOf("secure.com") !== -1; // $ Alert
	x.indexOf("secure.com") === -1; // $ Alert
	!(x.indexOf("secure.com") !== -1); // $ Alert
	!x.includes("secure.com"); // $ Alert

	if(!x.includes("secure.com")) { // $ Alert

	} else {
		doSomeThingWithTrustedURL(x);
    }

    x.startsWith("https://secure.com/foo/bar"); // OK - a forward slash after the domain makes prefix checks safe.
    x.indexOf("https://secure.com/foo/bar") >= 0 // $ Alert - the url can be anywhere in the string.
    x.indexOf("https://secure.com") >= 0 // $ Alert
    x.indexOf("https://secure.com/foo/bar-baz") >= 0 // $ Alert - the url can be anywhere in the string.
});
