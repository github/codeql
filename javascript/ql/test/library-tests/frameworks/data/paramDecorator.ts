import * as testlib from 'testlib';

// parameter decorators are only valid in TypeScript so this test is in a .ts file

class C {
  decoratedParamSource(@testlib.ParamDecoratorSource x) {
    sink(x) // NOT OK
  }
  decoratedParamSink(@testlib.ParamDecoratorSink x) { // NOT OK - though slightly weird alert location
  }
}

new C().decoratedParamSink(source());
