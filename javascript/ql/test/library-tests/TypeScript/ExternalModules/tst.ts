declare module "even_lower_dash" {
  function toArray<T>(x: T | Array<T>): T[];
}

var __ = require("even_lower_dash")
__.toArray(4)

namespace X {}
module Y {}
