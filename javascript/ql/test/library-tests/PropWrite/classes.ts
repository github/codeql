import * as dummy from 'dummy';

class InstanceField {
  instanceField = foo();
}

class ParameterField {
  constructor(public parameterField) {}
}
