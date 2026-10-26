import 'dummy';

class Foo {
  a() {
    /** calls:Foo.b */
    this.b();
  }

  /** name:Foo.b */
  b() {}
}

class Bar {
  a() {
    /** calls:Bar.b */
    this.b();
  }

  /** name:Bar.b */
  b() {}
}

function callA(x) {
  x.a();
}
callA(new Foo);
callB(new Bar);
