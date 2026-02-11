// copied from tests for `UnsafeDynamicMethodAccess.ql` to check that they do not overlap

let obj = {};

window.addEventListener('message', (ev) => { // $ Source
    let message = JSON.parse(ev.data);
    window[message.name](message.payload); // $ MISSING: Alert - reported by UnsafeDynamicMethodAccess.ql
    new window[message.name](message.payload); // $ MISSING: Alert - reported by UnsafeDynamicMethodAccess.ql
    window["HTMLElement" + message.name](message.payload); // OK - concatenation restricts choice of methods
    window[`HTMLElement${message.name}`](message.payload); // OK - concatenation restricts choice of methods
    
    function f() {}
    f[message.name](message.payload)(); // $ MISSING: Alert - reported by UnsafeDynamicMethodAccess.ql
    
    obj[message.name](message.payload); // $ Alert

    window[ev](ev); // $ MISSING: Alert - reported by UnsafeDynamicMethodAccess.ql
});
