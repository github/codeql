import type { Foo } from "foo";

export type { Foo };

var Foo = 45;

import type * as types from "types";

export type * as blah from "blah";
