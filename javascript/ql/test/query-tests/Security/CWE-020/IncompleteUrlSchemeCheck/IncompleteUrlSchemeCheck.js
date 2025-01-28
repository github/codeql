import * as dummy from 'dummy';

function sanitizeUrl(url) {
    let u = decodeURI(url).trim().toLowerCase();
    if (u.startsWith("javascript:")) // $ Alert
        return "about:blank";
    return url;
}

let badProtocols = ['javascript:', 'data:'];
let badProtocolNoColon = ['javascript', 'data'];
let badProtocolsGood = ['javascript:', 'data:', 'vbscript:'];

function test2(url) {
    let protocol = new URL(url).protocol;
    if (badProtocols.includes(protocol)) // $ Alert
        return "about:blank";
    return url;
}

function test3(url) {
    let scheme = goog.uri.utils.getScheme(url);
    if (badProtocolNoColon.includes(scheme)) // $ Alert
        return "about:blank";
    return url;
}

function test4(url) {
    let scheme = url.split(':')[0];
    if (badProtocolNoColon.includes(scheme)) // $ Alert
        return "about:blank";
    return url;
}

function test5(url) {
    let scheme = url.split(':')[0];
    if (scheme === "javascript") // $ Alert
        return "about:blank";
    return url;
}

function test6(url) {
    let protocol = new URL(url).protocol;
    if (badProtocolsGood.includes(protocol)) // OK
        return "about:blank";
    return url;
}

function test7(url) {
    let scheme = url.split(/:/)[0];
    if (scheme === "javascript") // $ Alert
        return "about:blank";
    return url;
}

function test8(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if ("javascript|data".split("|").indexOf(scheme) !== -1) // $ Alert
        return "about:blank";
    return url;
}

function test9(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if ("javascript" === scheme || "data" === scheme) // $ Alert
        return "about:blank";
    return url;
}

function test10(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if (/^(javascript|data)$/.exec(scheme) !== null) // $ Alert
        return "about:blank";
    return url;
}

function test11(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if (/^(javascript|data)$/.exec(scheme) === null) // $ Alert
		return url;
	return "about:blank";
}


function test12(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if (!/^(javascript|data)$/.exec(scheme)) // $ Alert
		return url;
	return "about:blank";
}

function test13(url) {
	let scheme = goog.uri.utils.getScheme(url);
	switch (scheme) { // $ Alert
    	case "javascript":
	    case "data":
		    return "about:blank";
	    default:
		    return url;
	}
}
function test14(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if (/^(javascript|data)$/.exec(scheme)) // $ Alert
        return "about:blank";
    return url;
}

function chain1(url) {
    return url
        .replace(/javascript:/, "")
        .replace(/data:/, ""); // $ Alert
}

function chain2(url) {
    return url  // OK
        .replace(/javascript:/, "")
        .replace(/data:/, "")
        .replace(/vbscript:/, "");
}

function chain3(url) {
    url = url.replace(/javascript:/, "")
    url = url.replace(/data:/, ""); // $ Alert
    return url;
}

function chain4(url) {
    return url.replace(/(javascript|data):/, ""); // $ MISSING: Alert
}
