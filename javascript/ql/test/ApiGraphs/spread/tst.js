const lib = require('something');

function f() {
    return {
        x: new Object() /* def (member x (parameter 0 (member m1 (member exports (module something))))) */
    }
}

lib.m1({
    ...f()
})
