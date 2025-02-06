eval(document.location.href.substring(document.location.href.indexOf("default=")+8)) // $ Alert

setTimeout(document.location.hash); // $ Alert


setTimeout(document.location.protocol);


$('. ' + document.location.hostname);

Function(document.location.search.replace(/.*\bfoo\s*=\s*([^;]*).*/, "$1")); // $ Alert

WebAssembly.compile(document.location.hash); // $ Alert

WebAssembly.compileStreaming(document.location.hash); // $ Alert

eval(atob(document.location.hash.substring(1))); // $ Alert

$('<a>').attr("onclick", location.search.substring(1)); // $ Alert

(function test() {
    var source = document.location.search.replace(/.*\bfoo\s*=\s*([^;]*).*/, "$1"); 

    new Function(source); // $ Alert[js/code-injection]

    Function(source); // $ Alert[js/code-injection]

    new Function("a", "b", source); // $ Alert[js/code-injection]

    new Function(...["a", "b"], source); // $ Alert[js/code-injection]
})();