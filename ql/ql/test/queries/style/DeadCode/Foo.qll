private module Mixed {
  private predicate dead1() { none() }

  predicate alive1() { none() }

  predicate dead2() { none() }
}

predicate usesAlive() { Mixed::alive1() }
