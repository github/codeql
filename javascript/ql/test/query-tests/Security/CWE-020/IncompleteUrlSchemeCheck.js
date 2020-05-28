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
