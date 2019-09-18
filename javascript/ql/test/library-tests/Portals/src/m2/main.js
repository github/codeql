export function foo(p) {
  console.log(p.x.y);
  p.z = "hi";
}

export default class {
  constructor(name) {
    this.name = name;
  }

  m(x) {
    console.log(x + " " + this.name);
  }

  static s(y) { return y; }
};
