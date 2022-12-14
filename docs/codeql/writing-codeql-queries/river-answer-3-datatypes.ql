/**
 * "Typesafe" solution to the river crossing puzzle.
 */

/** Either the left shore or the right shore. */
newtype TShore =
  Left() or
  Right()

class Shore extends TShore {
  Shore other() { result != this }

  string toString() {
    this = Left() and result = "left"
    or
    this = Right() and result = "right"
  }
}

newtype TMan = TManOn(Shore s)

/** Models the behavior of the man. */
class Man extends TMan {
  Shore s;

  Man() { this = TManOn(s) }

  /** Holds if the man is on a particular shore. */
  predicate isOn(Shore shore) { s = shore }

  /** Returns the other shore, after the man crosses the river. */
  Man cross() { result.isOn(s.other()) }

  /** Returns a cargo and its position after being ferried. */
  Cargo ferry(Cargo c) {
    result = c.cross() and
    c.isOn(s)
  }

  string toString() { result = "man " + s }
}

newtype TCargo =
  TGoat(Shore s) or
  TCabbage(Shore s) or
  TWolf(Shore s)

/** One of three possible cargo items, with their position. */
abstract class Cargo extends TCargo {
  Shore s;

  /** Holds if the cargo is on a particular shore. */
  predicate isOn(Shore shore) { s = shore }

  /** Returns the other shore, after the cargo crosses the river. */
  abstract Cargo cross();

  abstract string toString();
}

/** Models the position of the goat. */
class Goat extends Cargo, TGoat {
  Goat() { this = TGoat(s) }

  override Cargo cross() { result = TGoat(s.other()) }

  override string toString() { result = "goat " + s }
}

/** Models the position of the wolf. */
class Wolf extends Cargo, TWolf {
  Wolf() { this = TWolf(s) }

  override Cargo cross() { result = TWolf(s.other()) }

  override string toString() { result = "wolf " + s }
}

/** Models the position of the cabbage. */
class Cabbage extends Cargo, TCabbage {
  Cabbage() { this = TCabbage(s) }

  override Cargo cross() { result = TCabbage(s.other()) }

  override string toString() { result = "cabbage " + s }
}

newtype TState = Currently(Man man, Goat goat, Cabbage cabbage, Wolf wolf)

/** A record of where everything is. */
class State extends TState {
  Man man;
  Goat goat;
  Cabbage cabbage;
  Wolf wolf;

  State() { this = Currently(man, goat, cabbage, wolf) }

  /**
   * Returns the possible states that you can transition to
   * by ferrying one or zero cargo items.
   */
  State transition() {
    result = Currently(man.cross(), man.ferry(goat), cabbage, wolf) or
    result = Currently(man.cross(), goat, man.ferry(cabbage), wolf) or
    result = Currently(man.cross(), goat, cabbage, man.ferry(wolf)) or
    result = Currently(man.cross(), goat, cabbage, wolf)
  }

  /**
   * Returns all states that are reachable via a transition
   * and have not yet been visited.
   * `path` keeps track of how it is achieved.
   */
  State reachesVia(string path) {
    exists(string pathSoFar |
      result = this.reachesVia(pathSoFar).transition() and
      not exists(pathSoFar.indexOf(result.toString())) and
      path = pathSoFar + "\n" + result
    )
  }

  string toString() { result = man + "/" + goat + "/" + cabbage + "/" + wolf }
}

/** The initial state, where everything is on the left shore. */
class InitialState extends State {
  InitialState() {
    man.isOn(Left()) and goat.isOn(Left()) and cabbage.isOn(Left()) and wolf.isOn(Left())
  }

  override State reachesVia(string path) {
    path = this + "\n" + result and result = this.transition()
    or
    result = super.reachesVia(path)
  }

  override string toString() { result = "Initial: " + super.toString() }
}

/** The goal state, where everything is on the right shore. */
class GoalState extends State {
  GoalState() {
    man.isOn(Right()) and goat.isOn(Right()) and cabbage.isOn(Right()) and wolf.isOn(Right())
  }

  override State transition() { none() }

  override string toString() { result = "Goal: " + super.toString() }
}

/** An unsafe state, where something gets eaten. */
class IllegalState extends State {
  IllegalState() {
    exists(Shore s |
      goat.isOn(s) and cabbage.isOn(s) and not man.isOn(s)
      or
      wolf.isOn(s) and goat.isOn(s) and not man.isOn(s)
    )
  }

  override State transition() { none() }

  override string toString() { result = "ILLEGAL: " + super.toString() }
}

from string path
where any(InitialState i).reachesVia(path) = any(GoalState g)
select path
