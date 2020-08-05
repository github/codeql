function test(x) {
    let taint = source();

    if (/Hello (.*)/.exec(taint)) {
        sink(RegExp.$1); // NOT OK
    }

    if (/Foo (.*)/.exec(x)) {
        sink(RegExp.$1); // OK
    } else {
        sink(RegExp.$1); // NOT OK [INCONSISTENCY] - previous capture group remains
    }

    if (/Hello ([a-zA-Z]+)/.exec(taint)) {
        sink(RegExp.$1); // OK [INCONSISTENCY] - capture group is sanitized
    } else {
        sink(RegExp.$1); // NOT OK [found but for the wrong reason] - original capture group possibly remains
    }

    if (/Hello (.*)/.exec(taint) && something()) {
        sink(RegExp.$1); // NOT OK
    }
    if (something() && /Hello (.*)/.exec(taint)) {
        sink(RegExp.$1); // NOT OK
    }
    if (/First (.*)/.exec(taint) || /Second (.*)/.exec(taint)) {
        sink(RegExp.$1); // NOT OK
    }
}

function test2(x) {
    var taint = source();
    if (something()) {
        if (/Hello (.*)/.exec(taint)) {
            something();
        }
    }
    sink(RegExp.$1); // NOT OK
}

function replaceCallback() {
    return source().replace(/(\w+)/, () => {
        sink(RegExp.$1); // NOT OK
    });
}
