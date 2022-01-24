/**
 * @name River crossing puzzle
 * @description This implements the classical puzzle where a man is trying to
 * ferry a goat, a cabbage, and a wolf across a river.
 * His boat can only take himself and at most one item as cargo.
 * His problem is that if the goat is left alone with the cabbage,
 * it will eat it.
 * And if the wolf is left alone with the goat, it will eat it.
 * How does he get everything across the river?
 *
 * Note: Parts of this QL file are included in the corresponding .rst file.
 * Make sure to update the line numbers if you change anything here!
 */

/** A possible cargo item. */
class Cargo extends string {
  Cargo() {
    this = "Nothing" or
    this = "Goat" or
    this = "Cabbage" or
    this = "Wolf"
  }
}

/** One of two shores. */
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

  /**
   * Returns all states that are reachable via safe ferrying.
   * `path` keeps track of how it is achieved.
   * `visitedStates` keeps track of previously visited states and is used to avoid loops.
   */
  State reachesVia(string path, string visitedStates) {
    // Trivial case: a state is always reachable from itself.
    this = result and
    visitedStates = this and
    path = ""
    or
    // A state is reachable using pathSoFar and then safely ferrying cargo.
    exists(string pathSoFar, string visitedStatesSoFar, Cargo cargo |
      result = this.reachesVia(pathSoFar, visitedStatesSoFar).safeFerry(cargo) and
      // The resulting state has not yet been visited.
      not exists(visitedStatesSoFar.indexOf(result)) and
      visitedStates = visitedStatesSoFar + "/" + result and
      path = pathSoFar + "\n Ferry " + cargo
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
select path
