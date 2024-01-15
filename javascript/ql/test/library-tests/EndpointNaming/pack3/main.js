function ambiguousFunction(x, y, z) {} // $ method=(pack3).namedFunction

export default ambiguousFunction;
export { ambiguousFunction as namedFunction };

import libFunction from "./lib";
export { libFunction };
