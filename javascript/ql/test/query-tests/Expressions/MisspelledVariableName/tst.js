function f(errorMessage) {
  return errorMesage; // $ TODO-SPURIOUS: Alert
}

function g(errorMesage) {
  return errorMessage; // $ TODO-SPURIOUS: Alert
}

function h(errorMessage) {
  function inner() {
    return errorMesage; // $ TODO-SPURIOUS: Alert
  }
}

function k(errorMesage) {
  let inner = () =>
    errorMessage; // $ TODO-SPURIOUS: Alert
}

function foo() {
	var thisHander;
	thisHandler.foo1; // $ TODO-SPURIOUS: Alert
	thisHandler.foo2; // $ TODO-SPURIOUS: Alert
	thisHandler.foo3; // $ TODO-SPURIOUS: Alert
	thisHandler.foo4; // $ TODO-SPURIOUS: Alert
	thisHandler.foo5; // $ TODO-SPURIOUS: Alert
	thisHandler.foo6; // $ TODO-SPURIOUS: Alert
	thisHandler.foo7; // $ TODO-SPURIOUS: Alert
	thisHandler.foo8; // $ TODO-SPURIOUS: Alert
}