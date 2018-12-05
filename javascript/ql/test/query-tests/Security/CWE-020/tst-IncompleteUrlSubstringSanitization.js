(function(x){
    x.indexOf("internal"); // NOT OK, but not flagged
    x.indexOf("localhost"); // NOT OK, but not flagged
    x.indexOf("secure.com"); // NOT OK
    x.indexOf("secure.net"); // NOT OK
    x.indexOf(".secure.com"); // NOT OK
    x.indexOf("sub.secure."); // NOT OK, but not flagged
    x.indexOf(".sub.secure."); // NOT OK, but not flagged

    x.indexOf("secure.com") === -1; // NOT OK
    x.indexOf("secure.com") === 0; // NOT OK
    x.indexOf("secure.com") >= 0; // NOT OK

    x.startsWith("https://secure.com"); // NOT OK
    x.endsWith("secure.com"); // NOT OK
    x.endsWith(".secure.com"); // OK
    x.startsWith("secure.com/"); // OK
    x.indexOf("secure.com/") === 0; // OK

    x.includes("secure.com"); // NOT OK

    x.indexOf("#"); // OK
    x.indexOf(":"); // OK
    x.indexOf(":/"); // OK
    x.indexOf("://"); // OK
    x.indexOf("//"); // OK
    x.indexOf(":443"); // OK
    x.indexOf("/some/path/"); // OK
    x.indexOf("some/path"); // OK
    x.indexOf("/index.html"); // OK
    x.indexOf(":template:"); // OK
    x.indexOf("https://secure.com"); // NOT OK
    x.indexOf("https://secure.com:443"); // NOT OK
    x.indexOf("https://secure.com/"); // NOT OK

    x.indexOf(".cn"); // NOT OK, but not flagged
    x.indexOf(".jpg"); // OK
    x.indexOf("index.html"); // OK
    x.indexOf("index.js"); // OK
    x.indexOf("index.php"); // OK
    x.indexOf("index.css"); // OK

    x.indexOf("secure=true"); // OK (query param)
    x.indexOf("&auth="); // OK (query param)

    x.indexOf(getCurrentDomain()); // NOT OK, but not flagged
    x.indexOf(location.origin); // NOT OK, but not flagged

    x.indexOf("tar.gz") + offset // OK
    x.indexOf("tar.gz") - offset // OK

    x.indexOf("https://example.internal"); // NOT OK
    x.indexOf("https://"); // OK
});
