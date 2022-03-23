import * as testlib from 'testlib';

// parameter decorators are only valid in TypeScript so this test is in a .ts file

class C {
  decoratedParamSource(@testlib.ParamDecorator x) {
    sink(x) // NOT OK
  }
}
