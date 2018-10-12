/**
 * @name Missing super clone
 * @description A 'clone' method that is overridden in a subclass, and that does not itself call
 *              'super.clone', causes calls to the subclass's 'clone' method to return an object of
 *              the wrong type.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/missing-call-to-super-clone
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-580
 */

import java

from CloneMethod c, CloneMethod sc
where
  c.callsSuper(sc) and
  c.fromSource() and
  exists(sc.getBody()) and
  not exists(CloneMethod ssc | sc.callsSuper(ssc))
select sc, "This clone method does not call super.clone(), but is " + "overridden and called $@.",
  c, "in a subclass"
