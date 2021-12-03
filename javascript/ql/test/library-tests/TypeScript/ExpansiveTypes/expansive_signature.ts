import * as dummy from "./dummy";

interface ExpansiveSignature<T> {
  x: { (): ExpansiveSignature<T[]>; }
}

interface ExpansiveParameter<T> {
  x: { (param: ExpansiveParameter<T[]>): void; }
}

interface ExpansiveConstructSignature<T> {
  x: { new(): ExpansiveConstructSignature<T[]>; }
}

interface ExpansiveMethod<T> {
  method(): ExpansiveMethod<T[]>;
}

interface ExpansiveFunctionType<T> {
  x: () => ExpansiveFunctionType<T[]>;
}

interface ExpansiveSignatureTypeBound<T> {
  foo : { <G extends ExpansiveSignatureTypeBound<T[]>>(x: G): G };
}
