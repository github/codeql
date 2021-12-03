// copied from tests for `UnsafeDynamicMethodAccess.ql` to check that they do not overlap

let obj = {};

window.addEventListener('message', (ev) => {
    let message = JSON.parse(ev.data);
    window[message.name](message.payload); // NOT OK, but reported by UnsafeDynamicMethodAccess.ql [INCONSISTENCY]
    new window[message.name](message.payload); // NOT OK, but reported by UnsafeDynamicMethodAccess.ql [INCONSISTENCY]
    window["HTMLElement" + message.name](message.payload); // OK - concatenation restricts choice of methods
    window[`HTMLElement${message.name}`](message.payload); // OK - concatenation restricts choice of methods
    
    function f() {}
    f[message.name](message.payload)(); // NOT OK, but reported by UnsafeDynamicMethodAccess.ql [INCONSISTENCY]
    
    obj[message.name](message.payload); // NOT OK

    window[ev](ev); // NOT OK, but reported by UnsafeDynamicMethodAccess.ql [INCONSISTENCY]
});
