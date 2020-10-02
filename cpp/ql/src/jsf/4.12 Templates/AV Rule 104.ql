/**
 * @name AV Rule 104
 * @description A template specialization shall be declared before its use.
 * @kind problem
 * @id cpp/jsf/av-rule-104
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

/**
 * A compiler warning that a template specialization occurs after
 * what would have been its use. In C++ a template specialization
 * only applies after it is defined; if it would have applied had
 * it been defined earlier this warning is triggered.
 *
 * The warning is also triggered if the specialization would have
 * made a use ambiguous had it occurred earlier.
 */
class WarningLateTemplateSpecialization extends CompilerWarning {
  WarningLateTemplateSpecialization() {
    this.getTag() =
      ["partial_spec_after_instantiation", "partial_spec_after_instantiation_ambiguous"]
  }
}

from WarningLateTemplateSpecialization warning
select warning,
  "AV Rule 104: A template specialization shall be declared before its use; " + warning.getMessage()
    + "."
