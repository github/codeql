function f() {
  function inner() {}
  let arrow = () => 5;
  
  class C {
    method() {}
  };
  
  let obj = {
    get getter() {},
    set setter(x) {}
  };
}
