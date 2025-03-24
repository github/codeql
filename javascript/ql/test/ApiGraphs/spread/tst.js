const lib = require('something');

function f() {
    return {
        x: new Object() /* def=moduleImport("something").getMember("exports").getMember("m1").getParameter(0).getMember("x") */
    }
}

lib.m1({
    ...f()
})

function getArgs() {
    return [
        'x', /* def=moduleImport("something").getMember("exports").getMember("m2").getParameter(0) */
        'y', /* def=moduleImport("something").getMember("exports").getMember("m2").getParameter(1) */
    ]
}

lib.m2(...getArgs());
