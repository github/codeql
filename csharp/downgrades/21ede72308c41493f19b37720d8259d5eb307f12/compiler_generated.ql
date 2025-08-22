class Modifiable extends @modifiable {
  Modifiable() { compiler_generated(this) }

  string toString() { none() }
}

select any(Modifiable m)
