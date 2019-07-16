class A {
  constructor(f) {
    this._f = f;

  }

  m() {
    return this._f;
  }
}

var source = "source";
var a = new A(source);
var sink = a.m();

var source2 = "source2";
var a2 = new A(source2);
var sink2 = a.m.call(a2);
