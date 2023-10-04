function foo() {
    var url = document.location.toString();
    window.location = url.substring(0).substring(1); // OK
    window.location = url.substring(0, 10).substring(1); // OK
    window.location = url.substring(0, url.indexOf('/', 10)).substring(1); // OK
}

function bar() {
    var url = new URL(window.location);
    window.location = url.origin; // OK
    window.location = url.origin.substring(10); // OK
}
