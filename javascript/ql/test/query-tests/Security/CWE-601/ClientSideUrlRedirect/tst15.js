function foo() {
    var url = document.location.toString();
    window.location = url.substring(0).substring(1); // OK [INCONSISTENCY] - but not important
    window.location = url.substring(0, 10).substring(1); // OK [INCONSISTENCY]
    window.location = url.substring(0, url.indexOf('/', 10)).substring(1); // OK [INCONSISTENCY]

    var url2 = document.location.toString();
    window.location = url2.substring(0).substring(unknown()); // NOT OK
    window.location = url2.substring(0, 10).substring(unknown()); // NOT OK
    window.location = url2.substring(0, url2.indexOf('/', 10)).substring(unknown()); // NOT OK

    var search = document.location.search.toString();
    window.location = search.substring(0).substring(1); // NOT OK
    window.location = search.substring(0, 10).substring(1); // NOT OK
    window.location = search.substring(0, search.indexOf('/', 10)).substring(1); // NOT OK
}

function bar() {
    var url = new URL(window.location);
    window.location = url.origin; // OK
    window.location = url.origin.substring(10); // OK
}
