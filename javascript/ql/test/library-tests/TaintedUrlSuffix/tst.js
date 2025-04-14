import 'dummy';

function t1() {
    const href = window.location.href;

    sink(href); // $ flow=tainted-url-suffix

    sink(href.split('#')[0]); // could be 'tainted-url-suffix', but omitted due to FPs from URI-encoding
    sink(href.split('#')[1]); // $ flow=taint
    sink(href.split('#').pop()); // $ flow=taint
    sink(href.split('#')[2]); // $ MISSING: flow=taint // currently the split() summary only propagates to index 1

    sink(href.split('?')[0]);
    sink(href.split('?')[1]); // $ flow=taint
    sink(href.split('?').pop()); // $ flow=taint
    sink(href.split('?')[2]); // $ MISSING: flow=taint

    sink(href.split(blah())[0]); // $ flow=tainted-url-suffix
    sink(href.split(blah())[1]); // $ flow=tainted-url-suffix
    sink(href.split(blah()).pop()); // $ flow=tainted-url-suffix
    sink(href.split(blah())[2]); // $ flow=tainted-url-suffix
}
