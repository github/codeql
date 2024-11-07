type Output<K, S extends any[]> = {
  (...args: S): any;
};

declare function createThing<K extends string, S extends any[]>(
  type: K,
  fn: (...args: S) => any
): Output<K, S>;

const one = createThing("one", () => ({}));

const two = createThing("two", () => ({}));

const three = createThing("three", (cursor: string) => null);
const four = createThing("four", (error: number) => null);

type Events = Array<typeof one | typeof two | typeof three | typeof four>;
