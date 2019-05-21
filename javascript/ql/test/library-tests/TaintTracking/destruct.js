function test() {
  
  function f(obj) {
    let { x: { y: { z } } } = obj;
    sink(z); // NOT OK
    
    let [[[w]]] = obj;
    sink(w); // NOT OK
    
    let { x: [ { y: q } ] } = obj;
    sink(q); // NOT OK
  }
  
  function g() {
    f(source());
  }

}
