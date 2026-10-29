class Compilation extends @compilation {
  string toString() { none() }
}

from Compilation c, string cwd
where compilations(c, cwd)
select c, 1, /* Java compilation */ cwd, "<unnamed compilation>"
