import * as testlib from 'testlib';

// parameter decorators are only valid in TypeScript so this test is in a .ts file

class C {
  decoratedParamSource(@testlib.ParamDecoratorSource x) {
    sink(x) // NOT OK
  }
  decoratedParamSink(@testlib.ParamDecoratorSink x) { // NOT OK - though slightly weird alert location
  }
  decoratedParamSink2(@testlib.ParamDecoratorSink x) { // OK
    x.push(source());
  }
}

new C().decoratedParamSink(source());
new C().decoratedParamSink2([]);
