class C {
  f;
  
  constructor() {
    this.f = 5;
  }
}

class D {
  f = 4; // $ Alert
  
  constructor() {
    this.f = 5;
  }
}

class G {
  constructor(public h: string) { // $ Alert
    this.h = h;
  }
}
