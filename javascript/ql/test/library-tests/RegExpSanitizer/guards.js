function literals() {
    const value = source();
    sink(value); // $ flow

    if (/^[\w.-]+$/m.test(value)) {
        sink(value); // $ flow
    }
    if (/^[\w.-]+$/.test(value)) {
        sink(value);
    } else {
        sink(value); // $ flow
    }
    if (/^[\w.-]+$/i.test(value)) {
        sink(value);
    }
    if (/^[\w.-]+$/s.test(value)) {
        sink(value);
    }
    if (/^[\w.-]+$/m.exec(value)) {
        sink(value); // $ flow
    }
    if (/^[\w.-]+$/.exec(value)) {
        sink(value);
    }
    if (value.match(/^[\w.-]+$/m)) {
        sink(value); // $ flow
    }
    if (value.match(/^[\w.-]+$/)) {
        sink(value);
    }
    if (value.match("^[\\w.-]+$")) {
        sink(value);
    }
    if (value.matchAll(/^[\w.-]+$/gm)) {
        sink(value); // $ flow
    }
}

function references() {
    const value = source();
    const regexp = /^[\w.-]+$/m;
    if (regexp.test(value)) {
        sink(value); // $ flow
    }
    let match;
    if (match = regexp.exec(value)) {
        sink(value); // $ flow
    }
}

function constructors(flags) {
    const value = source();
    if (new RegExp("^[\\w.-]+$", "m").test(value)) {
        sink(value); // $ flow
    }
    if (RegExp("^[\\w.-]+$", "im").test(value)) {
        sink(value); // $ flow
    }
    const multiline = "m";
    if (new RegExp("^[\\w.-]+$", multiline).test(value)) {
        sink(value); // $ flow
    }
    if (new RegExp("^[\\w.-]+$", flags).test(value)) {
        sink(value); // $ flow
    }
    if (new RegExp("^[\\w.-]+$").test(value)) {
        sink(value);
    }
    if (new RegExp("^[\\w.-]+$", "").test(value)) {
        sink(value);
    }
    if (new RegExp("^[\\w.-]+$", "i").test(value)) {
        sink(value);
    }
    if (new RegExp(/^[\w.-]+$/m).test(value)) {
        sink(value); // $ flow
    }
    if (new RegExp(/^[\w.-]+$/, "m").test(value)) {
        sink(value); // $ flow
    }
}

function overriddenFlags() {
    const value = source();
    // Explicit overrides removing a literal's `m` flag are not currently covered by the sanitizer model.
    if (new RegExp(/^[\w.-]+$/m, "").test(value)) {
        sink(value); // $ SPURIOUS: flow
    }
    if (new RegExp(/^[\w.-]+$/m, "i").test(value)) {
        sink(value); // $ SPURIOUS: flow
    }
}

function groupsAndAlternatives() {
    const value = source();
    if (/(^[\w.-]+$)/m.test(value)) {
        sink(value); // $ flow
    }
    if (/(^[\w.-]+$)/.test(value)) {
        sink(value);
    }
    if (/^foo$|^bar$/m.test(value)) {
        sink(value); // $ flow
    }
    if (/^foo$|^bar$/.test(value)) {
        sink(value);
    }
}

function negativeChecks(flags) {
    const value = source();
    if (/[^a-z]/m.test(value)) {
        sink(value); // $ flow
    } else {
        sink(value);
    }
    if (!/\W/m.test(value)) {
        sink(value);
    }
    if (!new RegExp("[^a-z]", flags).test(value)) {
        sink(value);
    }
}
