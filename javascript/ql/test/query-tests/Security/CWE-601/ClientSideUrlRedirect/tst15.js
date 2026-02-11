function foo() {
    var url = document.location.toString(); // $ Source
    window.location = url.substring(0).substring(1); // $ SPURIOUS: Alert - but not important
    window.location = url.substring(0, 10).substring(1); // $ SPURIOUS: Alert
    window.location = url.substring(0, url.indexOf('/', 10)).substring(1); // $ SPURIOUS: Alert

    var url2 = document.location.toString(); // $ Source
    window.location = url2.substring(0).substring(unknown()); // $ Alert
    window.location = url2.substring(0, 10).substring(unknown()); // $ Alert
    window.location = url2.substring(0, url2.indexOf('/', 10)).substring(unknown()); // $ Alert

    var search = document.location.search.toString(); // $ Source
    window.location = search.substring(0).substring(1); // $ Alert
    window.location = search.substring(0, 10).substring(1); // $ Alert
    window.location = search.substring(0, search.indexOf('/', 10)).substring(1); // $ Alert
}

function bar() {
    var url = new URL(window.location);
    window.location = url.origin;
    window.location = url.origin.substring(10);
}
