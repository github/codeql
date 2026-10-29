import 'dummy';

function extractFromHash() {
    const [, group1] = /#(.*)/.exec(window.location.href); // $ Source
    window.location.href = group1; // $ Alert
}

function extractFromQuery() {
    const [, group1] = /\?(.*)/.exec(window.location.href); // $ Source
    window.location.href = group1; // $ Alert
}

function extractFromProtocol() {
    const [, group1] = /^([a-z]+:)/.exec(window.location.href);
    window.location.href = group1;
}

function extractTooMuch() {
    const [, group1] = /(.*)/.exec(window.location.href);
    window.location.href = group1;
}

function extractNothing() {
    const [, group1] = /blah#baz/.exec(window.location.href);
    window.location.href = group1;
}

function extractWithMatch() {
    const [, group1] = window.location.href.match(/#(.*)/); // $ Source
    window.location.href = group1; // $ Alert
}

function extractWithMatchAll() {
    const [, group1] = window.location.href.matchAll(/#(.*)/)[0]; // $ Source
    window.location.href = group1; // $ Alert
}

function extractFromUnknownRegExp() {
    const [, group1] = new RegExp(unknown()).exec(window.location.href); // $ Source
    window.location.href = group1; // $ Alert
}
