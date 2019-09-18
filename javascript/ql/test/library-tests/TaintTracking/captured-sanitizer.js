import * as dummy from 'dummy';

function f(x) {
  useVar();
  useVar();
  mutateVar();
  mutateVar();

  function useVar() {
    if (isSafe(x)) {
      causeReCapture();
      causeReCapture();
      sink(x); // OK
    }
    sink(x); // NOT OK
  }

  function causeReCapture() {}

  function mutateVar() {
    x = null;
  }
}

f(source());
