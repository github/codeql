class Factory1 {
  /** name:Factory1.build */
  build() {}
}

class Factory2 {
  /** name:Factory2.build */
  build() {}
}

class Factory3 {
  /** name:Factory3.build */
  build() {}
}

class Builder {
  factory1 = new Factory1();

  constructor(x) {
    this.factory2 = new Factory2();
    this.factory3 = x;
  }

  method() {
    /** calls:Factory1.build */
    this.factory1.build();
    /** calls:Factory2.build */
    this.factory2.build();
    /** calls:Factory3.build */
    this.factory3.build();

    let f1 = this.getFactory1();
    let f2 = this.getFactory2();
    let f3 = this.getFactory3();
    /** calls:Factory1.build */
    f1.build();
    /** calls:Factory2.build */
    f2.build();
    /** calls:Factory3.build */
    f3.build();
    
    /** calls:Builder.build */
    this.build();
  }

  getFactory1() {
    return this.factory1;
  }
  getFactory2() {
    return this.factory2;
  }
  getFactory3() {
    return this.factory3;
  }

  /** name:Builder.build */
  build() {}
}

let b = new Builder(new Factory3());

let bf1 = b.getFactory1();
let bf2 = b.getFactory2();
let bf3 = b.getFactory3();

/** calls:Factory1.build */
bf1.build();
/** calls:Factory2.build */
bf2.build();
/** calls:Factory3.build */
bf3.build();
