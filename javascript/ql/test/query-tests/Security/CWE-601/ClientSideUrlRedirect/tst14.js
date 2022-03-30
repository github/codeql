function foo() {
    var url = document.location.search.substr(1);
    var el = document.createElement("script");
    el.src = "https://github.com/" + url;
    document.body.appendChild(el); // OK

    if (url.startsWith('https://github.com/')) {
        window.location = url; // OK
    }
}
