/**
 * @name River crossing puzzle (version 1)
 * @description An "elementary" version of the solution to
 * the river crossing problem. It introduces more explicit and intuitive
 * definitions, before tidying them up in the "full" version.
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
  Shore() { this = "Left" or this = "Right" }

  /** Returns the other shore. */
  Shore other() {
    this = "Left" and result = "Right"
    or
    this = "Right" and result = "Left"
  }
}

/** A record of where everything is. */
class State extends string {
  Shore man;

  Shore goat;

  Shore cabbage;

  Shore wolf;

  State() { this = man + "," + goat + "," + cabbage + "," + wolf }

  State ferry(Cargo cargo) {
    cargo = "Nothing" and result = man.other() + "," + goat + "," + cabbage + "," + wolf
    or
    cargo = "Goat" and result = man.other() + "," + goat.other() + "," + cabbage + "," + wolf
    or
    cargo = "Cabbage" and result = man.other() + "," + goat + "," + cabbage.other() + "," + wolf
    or
    cargo = "Wolf" and result = man.other() + "," + goat + "," + cabbage + "," + wolf.other()
  }

  /**
   * Holds if predator and prey are on the same shore and the man
   * is not present.
   */
  predicate eats(Shore predator, Shore prey) { predator = prey and man != predator }

  /** Holds if nothing gets eaten in this state. */
  predicate isSafe() { not (eats(goat, cabbage) or eats(wolf, goat)) }

  /** Returns the state that is reached after safely ferrying a cargo item. */
  State safeFerry(Cargo cargo) { result = this.ferry(cargo) and result.isSafe() }

  /**
   * Returns all states that are reachable via safe ferrying.
   * `path` keeps track of how it is achieved and `steps` keeps track of the number of steps it takes.
   */
  State reachesVia(string path, int steps) {
    // Trivial case: a state is always reachable from itself
    steps = 0 and this = result and path = ""
    or
    // A state is reachable using pathSoFar and then safely ferrying cargo.
    exists(int stepsSoFar, string pathSoFar, Cargo cargo |
      result = this.reachesVia(pathSoFar, stepsSoFar).safeFerry(cargo) and
      steps = stepsSoFar + 1 and
       // We expect a solution in 7 steps, but you can choose any value here.
      steps <= 7 and
      path = pathSoFar + "\n Ferry " + cargo
    )
  }
}

/** The initial state, where everything is on the left shore. */
class InitialState extends State {
  InitialState() { this = "Left" + "," + "Left" + "," + "Left" + "," + "Left" }
}

/** The goal state, where everything is on the right shore. */
class GoalState extends State {
  GoalState() { this = "Right" + "," + "Right" + "," + "Right" + "," + "Right" }
}

from string path
where any(InitialState i).reachesVia(path, _) = any(GoalState g)
select path

