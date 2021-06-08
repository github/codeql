type Foo<T> = T extends (a, ...b: infer U) => any ? U : never
