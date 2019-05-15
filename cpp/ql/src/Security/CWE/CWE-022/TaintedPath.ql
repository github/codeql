/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an
 *              attacker to access unexpected resources.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/path-injection
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */

import cpp
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking

/**
 * A function for opening a file.
 */
class FileFunction extends FunctionWithWrappers {
  FileFunction() {
    exists(string nme | this.hasGlobalName(nme) |
      nme = "fopen" or
      nme = "_fopen" or
      nme = "_wfopen" or
      nme = "open" or
      nme = "_open" or
      nme = "_wopen" or

      // create file function on windows
      nme.matches("CreateFile%")
    )
    or
    (
      // on any of the fstream classes, or filebuf
      exists(string nme | this.getDeclaringType().getSimpleName() = nme |
        nme = "basic_fstream" or
        nme = "basic_ifstream" or
        nme = "basic_ofstream" or
        nme = "basic_filebuf"
      )
      and
      // we look for either the open method or the constructor
      (this.getName() = "open" or this instanceof Constructor)
    )
  }

  // conveniently, all of these functions take the path as the first parameter!
  override predicate interestingArg(int arg) {
    arg = 0
  }
}

from FileFunction fileFunction,
     Expr taintedArg, Expr taintSource, string taintCause, string callChain
where
  fileFunction.outermostWrapperFunctionCall(taintedArg, callChain) and
  tainted(taintSource, taintedArg) and
  isUserInput(taintSource, taintCause)
select
  taintedArg,
  "This argument to a file access function is derived from $@ and then passed to " + callChain,
  taintSource, "user input (" + taintCause + ")"
