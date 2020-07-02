import * as dummy from 'dummy';

function sanitizeUrl(url) {
    let u = decodeURI(url).trim().toLowerCase();
    if (u.startsWith("javascript:")) // NOT OK
        return "about:blank";
    return url;
}

let badProtocols = ['javascript:', 'data:'];
let badProtocolNoColon = ['javascript', 'data'];
let badProtocolsGood = ['javascript:', 'data:', 'vbscript:'];

function test2(url) {
    let protocol = new URL(url).protocol;
    if (badProtocols.includes(protocol)) // NOT OK
        return "about:blank";
    return url;
}

function test3(url) {
    let scheme = goog.uri.utils.getScheme(url);
    if (badProtocolNoColon.includes(scheme)) // NOT OK
        return "about:blank";
    return url;
}

function test4(url) {
    let scheme = url.split(':')[0];
    if (badProtocolNoColon.includes(scheme)) // NOT OK
        return "about:blank";
    return url;
}

function test5(url) {
    let scheme = url.split(':')[0];
    if (scheme === "javascript") // NOT OK
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
    if (scheme === "javascript") // NOT OK
        return "about:blank";
    return url;
}

function test8(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if ("javascript|data".split("|").indexOf(scheme) !== -1) // NOT OK
        return "about:blank";
    return url;
}

function test9(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if ("javascript" === scheme || "data" === scheme) // NOT OK
        return "about:blank";
    return url;
}

function test10(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if (/^(javascript|data)$/.exec(scheme) !== null) // NOT OK
        return "about:blank";
    return url;
}

function test11(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if (/^(javascript|data)$/.exec(scheme) === null) // NOT OK
		return url;
	return "about:blank";
}


function test12(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if (!/^(javascript|data)$/.exec(scheme)) // NOT OK
		return url;
	return "about:blank";
}

function test13(url) {
	let scheme = goog.uri.utils.getScheme(url);
	switch (scheme) {
    	case "javascript": // NOT OK
	    case "data":
		    return "about:blank";
	    default:
		    return url;
	}
}
function test14(url) {
    let scheme = goog.uri.utils.getScheme(url);
	if (/^(javascript|data)$/.exec(scheme)) // NOT OK
        return "about:blank";
    return url;
}
