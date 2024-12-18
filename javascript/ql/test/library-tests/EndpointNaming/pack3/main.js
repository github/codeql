function ambiguousFunction(x, y, z) {} // $ name=(pack3).namedFunction

export default ambiguousFunction; // $ alias=(pack3).default==(pack3).namedFunction
export { ambiguousFunction as namedFunction };

import libFunction from "./lib";
export { libFunction };
