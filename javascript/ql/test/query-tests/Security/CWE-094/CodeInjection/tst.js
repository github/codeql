// NOT OK
eval(document.location.href.substring(document.location.href.indexOf("default=")+8))

// NOT OK
setTimeout(document.location.hash);

// OK
setTimeout(document.location.protocol);

// OK
$('. ' + document.location.hostname);

// NOT OK
Function(document.location.search.replace(/.*\bfoo\s*=\s*([^;]*).*/, "$1"));

// NOT OK
WebAssembly.compile(document.location.hash);

// NOT OK
WebAssembly.compileStreaming(document.location.hash);

// NOT OK
eval(atob(document.location.hash.substring(1)));

// NOT OK
$('<a>').attr("onclick", location.search.substring(1));
