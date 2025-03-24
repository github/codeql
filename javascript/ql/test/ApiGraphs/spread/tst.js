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
        'x', /* def=moduleImport("something").getMember("exports").getMember("m2").getSpreadArgument(0).getArrayElement() */
        'y', /* def=moduleImport("something").getMember("exports").getMember("m2").getSpreadArgument(0).getArrayElement() */
    ]
}

lib.m2(...getArgs());
