document.write(document.location.href.charCodeAt(0));

document.write(document.location); // $ Alert
document.write(document.location.href); // $ Alert
document.write(document.location.href.valueOf()); // $ Alert
document.write(document.location.href.sup()); // $ Alert
document.write(document.location.href.toUpperCase()); // $ Alert
document.write(document.location.href.trimLeft()); // $ Alert
document.write(String.fromCharCode(document.location.href)); // $ Alert
document.write(String(document.location.href)); // $ Alert
document.write(escape(document.location.href)); // $ SPURIOUS: Alert
document.write(escape(escape(escape(document.location.href)))); // $ SPURIOUS: Alert
