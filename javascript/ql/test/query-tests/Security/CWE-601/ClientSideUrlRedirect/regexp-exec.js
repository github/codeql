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
    window.location.href = group1; // OK [INCONSISTENCY]
}

function extractTooMuch() {
    const [, group1] = /(.*)/.exec(window.location.href);
    window.location.href = group1; // OK [INCONSISTENCY]
}

function extractNothing() {
    const [, group1] = /blah#baz/.exec(window.location.href);
    window.location.href = group1; // OK [INCONSISTENCY]
}
