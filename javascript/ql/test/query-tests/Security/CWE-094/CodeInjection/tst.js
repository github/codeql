eval(document.location.href.substring(document.location.href.indexOf("default=")+8)) // $ Alert TODO-MISSING: Alert[js/unsafe-code-construction] Alert[js/bad-code-sanitization]

setTimeout(document.location.hash); // $ Alert TODO-MISSING: Alert[js/unsafe-code-construction] Alert[js/bad-code-sanitization]


setTimeout(document.location.protocol);


$('. ' + document.location.hostname);

Function(document.location.search.replace(/.*\bfoo\s*=\s*([^;]*).*/, "$1")); // $ Alert TODO-MISSING: Alert[js/unsafe-code-construction] Alert[js/bad-code-sanitization]

WebAssembly.compile(document.location.hash); // $ Alert TODO-MISSING: Alert[js/unsafe-code-construction] Alert[js/bad-code-sanitization]

WebAssembly.compileStreaming(document.location.hash); // $ Alert TODO-MISSING: Alert[js/unsafe-code-construction] Alert[js/bad-code-sanitization]

eval(atob(document.location.hash.substring(1))); // $ Alert TODO-MISSING: Alert[js/unsafe-code-construction] Alert[js/bad-code-sanitization]

$('<a>').attr("onclick", location.search.substring(1)); // $ Alert TODO-MISSING: Alert[js/unsafe-code-construction] Alert[js/bad-code-sanitization]

(function test() {
    var source = document.location.search.replace(/.*\bfoo\s*=\s*([^;]*).*/, "$1"); 

    new Function(source); // $ Alert[js/code-injection]

    Function(source); // $ Alert[js/code-injection]

    new Function("a", "b", source); // $ Alert[js/code-injection]

    new Function(...["a", "b"], source); // $ Alert[js/code-injection]
})();