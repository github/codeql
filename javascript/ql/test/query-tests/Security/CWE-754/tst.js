(function() {
  let obj = {
    foo() {}
  };

  window.addEventListener('message', (ev) => {
    let name = JSON.parse(ev.data).name;

    obj[ev.data](); // NOT OK: might not be a function

    obj[name]();    // NOT OK: might not be a function

    try {
      obj[name]();  // OK: exception is caught
    } catch(e) {}

    let fn = obj[name];
    fn();           // NOT OK: might not be a function
    if (typeof fn == 'function') {
      fn();         // NOT OK: might be `valueOf`
      obj[name]();  // NOT OK: might be `__defineSetter__`
      new fn();     // NOT OK: might be `valueOf` or `toString`
    }

    if (obj[name])
      obj[name]();  // NOT OK
    if (typeof obj[name] === 'function')
      obj[name]();  // NOT OK

    if (obj.hasOwnProperty(name)) {
      obj[name]();  // NOT OK, but not flagged [INCONSISTENCY]
    }

    let key = "$" + name;
    obj[key]();     // NOT OK
    if (typeof obj[key] === 'function')
      obj[key]();   // OK - but still flagged [INCONSISTENCY]

    if (typeof fn === 'function') {
      fn.apply(obj); // OK
    }
  });

  let obj2 = Object.create(null);
  obj2.foo = function() {};

  window.addEventListener('message', (ev) => {
    let name = JSON.parse(ev.data).name;
    let fn = obj2[name];
    fn();           // NOT OK: might not be a function
    if (typeof fn == 'function')
      fn();         // OK: cannot be from prototype
  });
})();
