import * as dummy from "./dummy";

class ExpansiveByInference<T> {
  x: T;
  y = new ExpansiveByInference([this.x]); // Inferred to be `ExpansiveByInference<T[]>`

  constructor(arg: T) {}
}
