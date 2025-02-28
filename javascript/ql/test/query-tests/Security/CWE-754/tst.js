(function() {
  let obj = {
    foo() {}
  };

  window.addEventListener('message', (ev) => { // $ Source
    let name = JSON.parse(ev.data).name;

    obj[ev.data](); // $ Alert - might not be a function

    obj[name]();    // $ Alert - might not be a function

    try {
      obj[name]();  // OK - exception is caught
    } catch(e) {}

    let fn = obj[name];
    fn();           // $ Alert - might not be a function
    if (typeof fn == 'function') {
      fn();         // $ Alert - might be `valueOf`
      obj[name]();  // $ Alert - might be `__defineSetter__`
      new fn();     // $ Alert - might be `valueOf` or `toString`
    }

    if (obj[name])
      obj[name]();  // $ Alert
    if (typeof obj[name] === 'function')
      obj[name]();  // $ Alert

    if (obj.hasOwnProperty(name)) {
      obj[name]();  // $ MISSING: Alert
    }

    let key = "$" + name;
    obj[key]();     // $ Alert
    if (typeof obj[key] === 'function')
      obj[key]();   // $ SPURIOUS: Alert

    if (typeof fn === 'function') {
      fn.apply(obj);
    }
  });

  let obj2 = Object.create(null);
  obj2.foo = function() {};

  window.addEventListener('message', (ev) => { // $ Source
    let name = JSON.parse(ev.data).name;
    let fn = obj2[name];
    fn();           // $ Alert - might not be a function
    if (typeof fn == 'function')
      fn();         // OK - cannot be from prototype
  });
})();
