import 'dummy';

function extractFromHash() {
    const [, group1] = /#(.*)/.exec(window.location.href);
    window.location.href = group1; // NOT OK
}

function extractFromQuery() {
    const [, group1] = /\?(.*)/.exec(window.location.href);
    window.location.href = group1; // NOT OK
}

function extractFromProtocol() {
    const [, group1] = /^([a-z]+:)/.exec(window.location.href);
    window.location.href = group1; // OK
}

function extractTooMuch() {
    const [, group1] = /(.*)/.exec(window.location.href);
    window.location.href = group1; // OK
}

function extractNothing() {
    const [, group1] = /blah#baz/.exec(window.location.href);
    window.location.href = group1; // OK
}

function extractWithMatch() {
    const [, group1] = window.location.href.match(/#(.*)/);
    window.location.href = group1; // NOT OK
}

function extractWithMatchAll() {
    const [, group1] = window.location.href.matchAll(/#(.*)/)[0];
    window.location.href = group1; // NOT OK
}

function extractFromUnknownRegExp() {
    const [, group1] = new RegExp(unknown()).exec(window.location.href);
    window.location.href = group1; // NOT OK
}
