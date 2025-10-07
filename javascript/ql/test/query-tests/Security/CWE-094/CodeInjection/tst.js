eval(document.location.href.substring(document.location.href.indexOf("default=")+8)) // $ Alert[js/code-injection]

setTimeout(document.location.hash); // $ Alert[js/code-injection]


setTimeout(document.location.protocol);


$('. ' + document.location.hostname);

Function(document.location.search.replace(/.*\bfoo\s*=\s*([^;]*).*/, "$1")); // $ Alert[js/code-injection]

WebAssembly.compile(document.location.hash); // $ Alert[js/code-injection]

WebAssembly.compileStreaming(document.location.hash); // $ Alert[js/code-injection]

eval(atob(document.location.hash.substring(1))); // $ Alert[js/code-injection]

$('<a>').attr("onclick", location.search.substring(1)); // $ Alert[js/code-injection]

(function test() {
    var source = document.location.search.replace(/.*\bfoo\s*=\s*([^;]*).*/, "$1");  // $ Source[js/code-injection]

    new Function(source); // $ Alert[js/code-injection]

    Function(source); // $ Alert[js/code-injection]

    new Function("a", "b", source); // $ Alert[js/code-injection]

    new Function(...["a", "b"], source); // $ Alert[js/code-injection]
})();