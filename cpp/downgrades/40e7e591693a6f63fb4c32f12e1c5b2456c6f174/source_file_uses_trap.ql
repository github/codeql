class Trap extends @trap {
  string toString() { none() }
}

from string source_file, Trap trap
where none()
select source_file, trap
