  // static index signature
  class Foo {
    static hello = "world";
    static [n: string]: string;
    [n: string]: boolean;
  }
  Foo["whatever"] = "foo";
  new Foo()["something"] = true;