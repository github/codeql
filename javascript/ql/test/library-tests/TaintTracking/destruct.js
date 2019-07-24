function test() {
  
  function f(obj) {
    let { x: { y: { z } } } = obj;
    sink(z); // NOT OK
    
    let [[[w]]] = obj;
    sink(w); // NOT OK
    
    let { x: [ { y: q } ] } = obj;
    sink(q); // NOT OK

    for (let [a, b] of obj) {
      sink(a); // NOT OK
      sink(b); // NOT OK
    }
  }
  
  function g() {
    f(source());
  }

}
