class C {
  foo() {
    let obj = {};
    obj.field = source();
    sink(obj.field); // NOT OK - tainted
    
    this.field2 = source();
    sink(this.field2); // NOT OK - tainted
  }
}
