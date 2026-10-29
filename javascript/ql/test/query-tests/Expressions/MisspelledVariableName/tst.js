function f(errorMessage) {
  return errorMesage; // $ Alert
}

function g(errorMesage) {
  return errorMessage; // $ Alert
}

function h(errorMessage) {
  function inner() {
    return errorMesage; // $ Alert
  }
}

function k(errorMesage) {
  let inner = () =>
    errorMessage; // $ Alert
}

function foo() {
	var thisHander;
	thisHandler.foo1; // $ Alert
	thisHandler.foo2; // $ Alert
	thisHandler.foo3; // $ Alert
	thisHandler.foo4; // $ Alert
	thisHandler.foo5; // $ Alert
	thisHandler.foo6; // $ Alert
	thisHandler.foo7; // $ Alert
	thisHandler.foo8; // $ Alert
}