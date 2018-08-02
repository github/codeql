function f(errorMessage) {
  return errorMesage;
}

function g(errorMesage) {
  return errorMessage;
}

function h(errorMessage) {
  function inner() {
    return errorMesage;
  }
}

function k(errorMesage) {
  let inner = () =>
    errorMessage;
}
