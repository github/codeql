class C {
  get x() { return 5; }
  
  get y() { return 5; }
  set y(value) {}
  
  set z(value) {}
  
  myMethod() {
    let myX = this.x;
    let myY = this.y;
    let myZ = this.z;
  }
}
