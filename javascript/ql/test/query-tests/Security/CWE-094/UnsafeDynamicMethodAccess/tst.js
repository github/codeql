let obj = {};

window.addEventListener('message', (ev) => { // $ Source
    let message = JSON.parse(ev.data);
    window[message.name](message.payload); // $ Alert - may invoke eval
    new window[message.name](message.payload); // $ Alert - may invoke jQuery $ function or similar
    window["HTMLElement" + message.name](message.payload); // OK - concatenation restricts choice of methods
    window[`HTMLElement${message.name}`](message.payload); // OK - concatenation restricts choice of methods
    
    function f() {}
    f[message.name](message.payload)(); // $ Alert - may acccess Function constructor
    
    obj[message.name](message.payload); // OK - may crash, but no code execution involved

    window[ev](ev); // $ Alert

    window[configData() + ' ' + message.name](message.payload); // OK - concatenation restricts choice of methods

    window[configData() + message.name](message.payload); // OK - concatenation restricts choice of methods

    window['' + message.name](message.payload); // $ Alert - coercion does not restrict choice of methods
});
