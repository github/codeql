/**
 * A solution to the river crossing puzzle using a modified `path` variable
 * to describe the resulting path in detail.
 */

/** A possible cargo item. */
class Cargo extends string {
  Cargo() { this = ["Nothing", "Goat", "Cabbage", "Wolf"] }
}

/** A shore, named either `Left` or `Right`. */
class Shore extends string {
  Shore() {
    this = "Left" or
    this = "Right"
  }

  /** Returns the other shore. */
  Shore other() {
    this = "Left" and result = "Right"
    or
    this = "Right" and result = "Left"
  }
}

/** Renders the state as a string. */
string renderState(Shore manShore, Shore goatShore, Shore cabbageShore, Shore wolfShore) {
  result = manShore + "," + goatShore + "," + cabbageShore + "," + wolfShore
}

/** A record of where everything is. */
class State extends string {
  Shore manShore;
  Shore goatShore;
  Shore cabbageShore;
  Shore wolfShore;

  State() { this = renderState(manShore, goatShore, cabbageShore, wolfShore) }

  /** Returns the state that is reached after ferrying a particular cargo item. */
  State ferry(Cargo cargo) {
    cargo = "Nothing" and
    result = renderState(manShore.other(), goatShore, cabbageShore, wolfShore)
    or
    cargo = "Goat" and
    result = renderState(manShore.other(), goatShore.other(), cabbageShore, wolfShore)
    or
    cargo = "Cabbage" and
    result = renderState(manShore.other(), goatShore, cabbageShore.other(), wolfShore)
    or
    cargo = "Wolf" and
    result = renderState(manShore.other(), goatShore, cabbageShore, wolfShore.other())
  }

  /**
   * Holds if the state is safe. This occurs when neither the goat nor the cabbage
   * can get eaten.
   */
  predicate isSafe() {
    // The goat can't eat the cabbage.
    (goatShore != cabbageShore or goatShore = manShore) and
    // The wolf can't eat the goat.
    (wolfShore != goatShore or wolfShore = manShore)
  }

  /** Returns the state that is reached after safely ferrying a cargo item. */
  State safeFerry(Cargo cargo) { result = this.ferry(cargo) and result.isSafe() }

  string towards() {
    manShore = "Left" and result = "to the left"
    or
    manShore = "Right" and result = "to the right"
  }

  /**
   * Returns all states that are reachable via safe ferrying.
   * `path` keeps track of how it is achieved.
   * `visitedStates` keeps track of previously visited states and is used to avoid loops.
   */
  State reachesVia(string path, string visitedStates) {
    // Reachable in 1 step by ferrying a specific cargo
    exists(Cargo cargo |
      result = this.safeFerry(cargo) and
      visitedStates = result and
      path = "First " + cargo + " is ferried " + result.towards()
    )
    or
    // Reachable by first following pathSoFar and then ferrying cargo
    exists(string pathSoFar, string visitedStatesSoFar, Cargo cargo |
      result = this.reachesVia(pathSoFar, visitedStatesSoFar).safeFerry(cargo) and
      not exists(visitedStatesSoFar.indexOf(result)) and // resulting state is not visited yet
      visitedStates = visitedStatesSoFar + "_" + result and
      path = pathSoFar + ",\nthen " + cargo + " is ferried " + result.towards()
    )
  }
}

/** The initial state, where everything is on the left shore. */
class InitialState extends State {
  InitialState() { this = renderState("Left", "Left", "Left", "Left") }
}

/** The goal state, where everything is on the right shore. */
class GoalState extends State {
  GoalState() { this = renderState("Right", "Right", "Right", "Right") }
}

from string path
where any(InitialState i).reachesVia(path, _) = any(GoalState g)
select path + "."
