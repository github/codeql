import * as dummy from 'dummy';

class InstanceField {
  instanceField = foo();
}

class ParameterField {
  constructor(public parameterField) {}
}

class ParameterFieldInit  {
    constructor(public parameterField = {}) { parameterField + 42; }
}

class ParameterFieldInitUnused  {
    constructor(public parameterField = {}) {}
}
