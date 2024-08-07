import * as lib from 'lib';

function foo(source_param, callback) {
    sink(source_param); // $ hasValueFlow=source_param hasValueFlow=explicit_source
    callback(source_param);
    return source_param;
}

lib.something(foo);

function unrelated() {
    let ret = foo('safe', p => {
        sink(p);
    });
    sink(ret);
}

function related() {
    let ret = foo(source('explicit_source'), p => {
        sink(p); // $ hasValueFlow=explicit_source
    });
    sink(ret); // $ hasValueFlow=explicit_source
}
