/**
 * A solution to the river crossing puzzle using abstract
 * classes/predicates to model the situation and unicode
 * symbols to display the answer.
 */

/** One of two shores. */
class Shore extends string {
  Shore() { this = "left" or this = "right" }
}

/** Models the behavior of the man. */
class Man extends string {
  Shore s;

  Man() { this = "man " + s }

  /** Holds if the man is on a particular shore. */
  predicate isOn(Shore shore) { s = shore }

  /** Returns the other shore, after the man crosses the river. */
  Man cross() { result != this }

  /** Returns a cargo and its position after being ferried. */
  Cargo ferry(Cargo c) {
    result = c.cross() and
    c.isOn(s)
  }
}

/** One of three possible cargo items, with their position. */
abstract class Cargo extends string {
  Shore s;

  bindingset[this]
  Cargo() { any() }

  /** Holds if the cargo is on a particular shore. */
  predicate isOn(Shore shore) { s = shore }

  /** Returns the other shore, after the cargo crosses the river. */
  abstract Cargo cross();
}

/** Models the position of the goat. */
class Goat extends Cargo {
  Goat() { this = "goat " + s }

  override Goat cross() { result != this }
}

/** Models the position of the wolf. */
class Wolf extends Cargo {
  Wolf() { this = "wolf " + s }

  override Wolf cross() { result != this }
}

/** Models the position of the cabbage. */
class Cabbage extends Cargo {
  Cabbage() { this = "cabbage " + s }

  override Cabbage cross() { result != this }
}

/** Returns a unicode representation of everything on the left shore. */
string onLeft(Man man, Goat goat, Cabbage cabbage, Wolf wolf) {
  exists(string manOnLeft, string goatOnLeft, string cabbageOnLeft, string wolfOnLeft |
    (
      man.isOn("left") and manOnLeft = "🕴"
      or
      man.isOn("right") and manOnLeft = "____"
    ) and
    (
      goat.isOn("left") and goatOnLeft = "🐐"
      or
      goat.isOn("right") and goatOnLeft = "___"
    ) and
    (
      cabbage.isOn("left") and cabbageOnLeft = "🥬"
      or
      cabbage.isOn("right") and cabbageOnLeft = "___"
    ) and
    (
      wolf.isOn("left") and wolfOnLeft = "🐺"
      or
      wolf.isOn("right") and wolfOnLeft = "___"
    ) and
    result = manOnLeft + "__" + goatOnLeft + "__" + cabbageOnLeft + "__" + wolfOnLeft
  )
}

/** Returns a unicode representation of everything on the right shore. */
string onRight(Man man, Goat goat, Cabbage cabbage, Wolf wolf) {
  exists(string manOnLeft, string goatOnLeft, string cabbageOnLeft, string wolfOnLeft |
    (
      man.isOn("right") and manOnLeft = "🕴"
      or
      man.isOn("left") and manOnLeft = "_"
    ) and
    (
      goat.isOn("right") and goatOnLeft = "🐐"
      or
      goat.isOn("left") and goatOnLeft = "__"
    ) and
    (
      cabbage.isOn("right") and cabbageOnLeft = "🥬"
      or
      cabbage.isOn("left") and cabbageOnLeft = "__"
    ) and
    (
      wolf.isOn("right") and wolfOnLeft = "🐺"
      or
      wolf.isOn("left") and wolfOnLeft = "__"
    ) and
    result = manOnLeft + "__" + goatOnLeft + "__" + cabbageOnLeft + "__" + wolfOnLeft
  )
}

/** Renders the state as a string, using unicode symbols. */
string render(Man man, Goat goat, Cabbage cabbage, Wolf wolf) {
  result =
    onLeft(man, goat, cabbage, wolf) + "___🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊___" +
      onRight(man, goat, cabbage, wolf)
}

/** A record of where everything is. */
class State extends string {
  Man man;
  Goat goat;
  Cabbage cabbage;
  Wolf wolf;

  State() { this = render(man, goat, cabbage, wolf) }

  /**
   * Returns the possible states that you can transition to
   * by ferrying one or zero cargo items.
   */
  State transition() {
    result = render(man.cross(), man.ferry(goat), cabbage, wolf) or
    result = render(man.cross(), goat, man.ferry(cabbage), wolf) or
    result = render(man.cross(), goat, cabbage, man.ferry(wolf)) or
    result = render(man.cross(), goat, cabbage, wolf)
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
      path = pathSoFar + "\n↓\n" + result
    )
  }
}

/** The initial state, where everything is on the left shore. */
class InitialState extends State {
  InitialState() {
    exists(Shore left | left = "left" |
      man.isOn(left) and goat.isOn(left) and cabbage.isOn(left) and wolf.isOn(left)
    )
  }

  override State reachesVia(string path) {
    path = this + "\n↓\n" + result and result = this.transition()
    or
    result = super.reachesVia(path)
  }
}

/** The goal state, where everything is on the right shore. */
class GoalState extends State {
  GoalState() {
    exists(Shore right | right = "right" |
      man.isOn(right) and goat.isOn(right) and cabbage.isOn(right) and wolf.isOn(right)
    )
  }

  override State transition() { none() }
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
}

from string path
where any(InitialState i).reachesVia(path) = any(GoalState g)
select path
