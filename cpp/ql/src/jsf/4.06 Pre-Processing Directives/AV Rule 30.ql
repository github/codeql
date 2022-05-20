/**
 * @name AV Rule 30
 * @description The #define pre-processor directive shall not be used to define constant values. Instead, the const qualifier shall be applied to variable declarations to specify constant values.
 * @kind problem
 * @id cpp/jsf/av-rule-30
 * @problem.severity error
 * @tags maintainability
 *       external/jsf
 */

import cpp

/** A macro defining a simple constant. */
class ConstantDefMacro extends Macro {
  ConstantDefMacro() {
    // Exclude functions
    not this.getHead().matches("%(%") and
    exists(string body |
      body = this.getBody() and
      // Empty defines are allowed (rule 31 restricts their use though)
      body != "" and
      // No special characters in the body
      not body.matches("%(%") and
      not body.matches("%{%")
    )
  }
}

/** List macros that are 'common' and should be excluded */
predicate commonMacro(string name) {
  name = "NULL" // TODO
}

from ConstantDefMacro m
where
  not commonMacro(m.getHead()) and
  m.fromSource()
select m, "The #define pre-processor directive shall not be used to define constant values."
