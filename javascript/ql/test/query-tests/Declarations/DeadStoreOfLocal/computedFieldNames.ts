import dummy from 'dummy';

var key1 = "key1";
export class NoConstructor {
  [key1] = 4;
}

var key2 = "key2";
export class WithConstructor {
  [key2] = 4;

  constructor() {}
}
