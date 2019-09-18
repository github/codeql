class C {
  constructor(x) {
    this.x = x;
  }

  method() {
    this.x;
    let closure = () => this.x;
  }

  get getter() {
    return this.x;
  }
}
