type T1 = 'foo' | 'bar';
type T2 = `foo ${T1}`;

type FooToBar<K extends string> = K extends `foo` ? `bar` : K;
type FooToBar2<K extends string> = K extends `foo` ? `bar ${K}` : K;

type Tuple = [`foo`?];
