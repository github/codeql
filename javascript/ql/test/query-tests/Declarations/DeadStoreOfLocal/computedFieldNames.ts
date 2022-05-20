import dummy from 'dummy';

var key1 = "key1"; // OK
export class NoConstructor {
  [key1] = 4;
}

var key2 = "key2"; // OK
export class WithConstructor {
  [key2] = 4;

  constructor() {}
}
