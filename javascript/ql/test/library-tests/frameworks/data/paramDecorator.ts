import * as testlib from 'testlib';

// parameter decorators are only valid in TypeScript so this test is in a .ts file

class C {
  decoratedParamSource(@testlib.ParamDecoratorSource x) {
    sink(x) // NOT OK
  }
  decoratedParamSink(@testlib.ParamDecoratorSink x) { // OK
  }
  decoratedParamSink2(@testlib.ParamDecoratorSink x) { // OK
    x.push(source()); // OK
  }
}

new C().decoratedParamSink(source()); // OK - parameter decorators can't be used to mark the parameter as a sink
new C().decoratedParamSink2([]); // OK
