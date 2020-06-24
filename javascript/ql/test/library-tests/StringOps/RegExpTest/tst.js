import 'dummy';

const regexp = /^[a-z]+$/;

function f(str) {
    if (/^[a-z]+$/.test(str)) {}
    if (/^[a-z]+$/.exec(str) != null) {}
    if (/^[a-z]+$/.exec(str)) {}
    if (str.match(/^[a-z]+$/)) {}
    if (str.match("^[a-z]+$")) {}

    if (regexp.test(str)) {}
    if (regexp.exec(str) != null) {}
    if (regexp.exec(str)) {}
    if (str.match(regexp)) {}

    let match = regexp.exec(str);
    if (match) {}
    if (!match) {}
    if (match == null) {}
    if (match != null) {}
    if (match && match[1] == "") {}

    something({
        someOption: !!match
    });

    something({
        someOption: regexp.test(str)
    });

    something({
        someOption: !!str.match(regexp)
    });

    something({
        someOption: regexp.exec(str) // not recognized as RegExpTest
    })

    if (regexp.exec(str) == undefined) {}
    if (regexp.exec(str) === undefined) {} // not recognized as RegExpTest

    let match2 = str.match(regexp);
    if (match2) {}
    if (!match2) {}
}

function something() {}

f("some string");
f("someotherstring");
