document.write(document.location.href.charCodeAt(0)); // OK

document.write(document.location); // NOT OK
document.write(document.location.href); // NOT OK
document.write(document.location.href.valueOf()); // NOT OK
document.write(document.location.href.sup()); // NOT OK
document.write(document.location.href.toUpperCase()); // NOT OK
document.write(document.location.href.trimLeft()); // NOT OK
document.write(String.fromCharCode(document.location.href)); // NOT OK
document.write(String(document.location.href)); // NOT OK
document.write(escape(document.location.href)); // OK (for now)
document.write(escape(escape(escape(document.location.href)))); // OK (for now)
