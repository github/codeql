// Only the type is exposed. For the time being we do not consider type-only declarations or .d.ts files
// when naming classes.
export type { Foo } from "./foo";

import * as foo from "./foo";

export function expose() {
    return new foo.Foo(); // expose an instance of Foo but not the class
} // $ name=(pack9).expose
