import { "Foo::new" as Foo_new } from "./foo.wasm"

const foo = Foo_new()

export { Foo_new as "Foo::new" }
export type * as "Foo_types" from './mod'