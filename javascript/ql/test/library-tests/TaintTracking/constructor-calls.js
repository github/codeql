class EcmaClass {
  constructor(param) {
    this.param = param;
    this.taint = source();
  }
}

function JsClass(param) {
  this.param = param;
  this.taint = source();
}

function test() {
  let taint = source();

  let c = new EcmaClass(taint);
  sink(c.param); // NOT OK
  sink(c.taint); // NOT OK
  
  let c_safe = new EcmaClass("safe");
  sink(c_safe.param); // OK
  sink(c_safe.taint); // NOT OK
  
  let d = new JsClass(taint);
  sink(d.param); // NOT OK
  sink(d.taint); // NOT OK
  
  let d_safe = new JsClass("safe");
  sink(d_safe.param); // OK
  sink(d_safe.taint); // NOT OK
}
