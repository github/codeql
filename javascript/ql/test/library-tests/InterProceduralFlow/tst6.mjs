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
