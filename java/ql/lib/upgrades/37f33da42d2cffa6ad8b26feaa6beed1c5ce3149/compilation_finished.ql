class Compilation extends @compilation {
  string toString() { none() }
}

from Compilation c, float cpu_seconds, float elapsed_seconds
where compilation_finished(c, cpu_seconds, elapsed_seconds)
select c, cpu_seconds, elapsed_seconds, /* success */ 0
