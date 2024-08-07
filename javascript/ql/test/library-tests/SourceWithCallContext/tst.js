import * as lib from 'lib';

function foo(source_param, callback) {
    sink(source_param); // $ hasValueFlow=source_param
    callback(source_param);
    return source_param;
}

lib.something(foo);

function unrelated() {
    let ret = foo('safe', p => {
        sink(p); // $ hasValueFlow=source_param [SPURIOUS]
    });
    sink(ret);
}
