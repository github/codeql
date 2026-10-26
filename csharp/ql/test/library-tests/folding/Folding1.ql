/**
 * @name Test that the results of constant folding are recorded, but that the
 *       original AST is populated.
 */

import csharp

string lost(LocalVariable v) {
  v.fromSource() and
  v.getInitializer() instanceof Literal and
  result = "Folded literal populated - original lost"
}

string noValue(LocalVariable v) {
  v.fromSource() and
  v.getInitializer() instanceof Literal and
  result = "No constant value recorded"
}

string correct(LocalVariable v) {
  v.fromSource() and
  exists(v.getInitializer()) and
  not exists(lost(v)) and
  not exists(noValue(v)) and
  result = "Correct"
}

from LocalVariable v, string msg
where
  msg = lost(v) or
  msg = noValue(v) or
  msg = correct(v)
select v, msg
