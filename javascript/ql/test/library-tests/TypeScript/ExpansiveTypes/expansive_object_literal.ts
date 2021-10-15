import * as dummy from "./dummy";

interface ExpandUsingObjectLiteral<T> {
  x: {
    foo: ExpandUsingObjectLiteral<T[]>
  }
}
