export type Foo<R> = <A>() => Foo<R | A>;

export type Bar<R> = <A>() => Bar<[R, A]>;

export type Baz<R> = <A>() => Baz<(x: R) => A>;
