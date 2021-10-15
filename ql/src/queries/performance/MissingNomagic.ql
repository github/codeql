/**
 * @name Candidate predicate not marked as `nomagic`
 * @description A candidate predicate should be marked as `nomagic` to prevent unnecessary computation.
 * @kind problem
 * @problem.severity warning
 * @id ql/cand-missing-nomagic
 * @tags performance
 * @precision medium
 */

import ql

/**
 * Holds if the set of tuples satisfying `cand` is an upper bound for
 * the set of tuples satisfying `f`
 */
predicate guards(Predicate cand, Formula f) {
  forex(Formula child | child = f.(Disjunction).getAnOperand() | guards(cand, child))
  or
  guards(cand, f.(Conjunction).getAnOperand())
  or
  exists(Call call | f = call |
    call.getTarget() = cand
    or
    guards(cand, call.getTarget().(Predicate).getBody())
  )
  or
  exists(Quantifier q | f = q | guards(cand, [q.getFormula(), q.getRange()]))
  or
  exists(IfFormula ifFormula | ifFormula = f |
    guards(cand, ifFormula.getThenPart()) and guards(cand, ifFormula.getElsePart())
  )
}

pragma[noinline]
predicate hasNameWithNumberSuffix(Predicate p, string name, int n) {
  n = [1 .. 10] and
  p.getName() = name + n.toString()
}

/**
 * A candidate predicate for another predicate.
 *
 * A predicate `p0` is a candidate for another predicate `p` when the tuples
 * that satisfy `p0` upper bounds the set of tuples that satisfy `p`.
 */
class CandidatePredicate extends Predicate {
  Predicate pred;

  CandidatePredicate() {
    // This predicate "guards" the predicate `pred` (i.e., it's always evaluated before `pred`).
    guards(this, pred.getBody()) and
    (
      // The name of `pred` is "foo", and the name of this predicate is `foo0`, or `fooHelper`, or any
      // other the other cases.
      pragma[only_bind_into](pred).getName() =
        this.getName()
            .regexpCapture("(.+)" + ["0", "helper", "aux", "cand", "Helper", "Aux", "Cand"], 1)
      or
      // Or this this predicate is named "foo02" and `pred` is named "foo01".
      exists(int n, string name |
        hasNameWithNumberSuffix(pred, name, n) and
        hasNameWithNumberSuffix(this, name, n - 1)
      )
    )
  }

  /** Holds if this predicate is a candidate predicate for `p`. */
  predicate isCandidateFor(Predicate p) { p = pred }
}

from CandidatePredicate cand, Predicate pred
where
  // The candidate predicate is not in a test directory.
  not cand.getLocation().getFile().getAbsolutePath().matches("%/" + ["meta", "test"] + "/%") and
  cand.isCandidateFor(pred) and
  not cand.getAnAnnotation() instanceof NoMagic and
  not cand.getAnAnnotation() instanceof NoOpt
select cand, "Candidate predicate to $@ is not marked as nomagic.", pred, pred.getName()
