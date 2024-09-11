import 'dummy';

function t1() {
    const href = window.location.href;

    sink(href); // $ flow=tainted-url-suffix

    sink(href.split('#')[0]); // $ MISSING: flow=tainted-url-suffix
    sink(href.split('#')[1]); // $ flow=taint
    sink(href.split('#').pop()); // $ flow=taint
    sink(href.split('#')[2]); // $ flow=taint

    sink(href.split('?')[0]); // $ MISSING: flow=tainted-url-suffix
    sink(href.split('?')[1]); // $ flow=taint
    sink(href.split('?').pop()); // $ flow=taint
    sink(href.split('?')[2]); // $ flow=taint

    sink(href.split(blah())[0]); // $ flow=tainted-url-suffix
    sink(href.split(blah())[1]); // $ flow=tainted-url-suffix
    sink(href.split(blah()).pop()); // $ flow=tainted-url-suffix
    sink(href.split(blah())[2]); // $ flow=tainted-url-suffix
}
