let plain: number[];
let readonly: ReadonlyArray<number>;
let tuple: [number, string];

interface NumberIndexable {
  length: number;
  [n: number]: object;
}

interface StringIndexable {
  length: number;
  [n: string]: object;
}

let numberIndexable: NumberIndexable;
let stringIndexable: StringIndexable;

let readonlySyntax: readonly number[];
let readonlySyntax2: readonly number[][];
