class C {
  static instance: C = new C();
}

export class D {
  static instance: D = new D();
}

export class E {
  static f: C | boolean = false;
  static {
    E.f = new C();
  }
  static g: D | number = 1337;
  static {
    E.g = new D();
  }
}