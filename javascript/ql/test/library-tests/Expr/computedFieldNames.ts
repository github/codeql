const key1 = "key1";
class NoConstructor {
  [key1] = 4;
}

const key2 = "key2";
class WithConstructor {
  [key2] = 4;

  constructor() {}
}
