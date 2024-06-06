import "module" with { type: "json" };
import * as v1 from "module" with { type: "json" };
import { v2 } from "module" with { type: "json" };
import v3 from "module" with { type: "json" };

export { v4 } from "module" with { type: "json" };
export * from "module" with { type: "json" };
export * as v5 from "module" with { type: "json" };

const v6 = import("module", { with: { type: "json" } });

import "module" // missing semicolon
assert({type: "json"}); // function call, not import assertion

import "module" assert { type: "json" };
import * as v1 from "module" assert { type: "json" };
import { v2 } from "module" assert { type: "json" };
import v3 from "module" assert { type: "json" };

export { v4 } from "module" assert { type: "json" };
export * from "module" assert { type: "json" };
export * as v5 from "module" assert { type: "json" };

const v6 = import("module", { assert: { type: "json" } });
