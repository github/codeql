import ql

module Firebase {
  module Database {
    query predicate ref(int i) { i = snapshot() }
  }

  int snapshot() { result = 2 }
}
