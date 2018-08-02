/**
 * @name Use of inherently dangerous function
 * @description Using a library function that does not check buffer bounds
 *              requires the surrounding program to be very carefully written
 *              to avoid buffer overflows.
 * @kind problem
 * @id cpp/potential-buffer-overflow
 * @problem.severity warning
 * @tags reliability
 *       security
 *       external/cwe/cwe-242
 */
import cpp
import semmle.code.cpp.commons.Buffer

abstract class PotentiallyDangerousFunctionCall extends FunctionCall {
  abstract predicate isDangerous();
  abstract string getDescription();
}

class GetsCall extends PotentiallyDangerousFunctionCall {
  GetsCall() {
    this.getTarget().hasName("gets")
  }

  override predicate isDangerous() {
    any()
  }

  override string getDescription() {
    result = "gets does not guard against buffer overflow"
  }
}

class SprintfCall extends PotentiallyDangerousFunctionCall {
  SprintfCall() {
    this.getTarget().hasName("sprintf") or this.getTarget().hasName("vsprintf")
  }

  int getBufferSize() {
    result = getBufferSize(this.getArgument(0), _)
  }

  int getMaxConvertedLength() {
    result = this.getArgument(1).(FormatLiteral).getMaxConvertedLength()
  }

  override predicate isDangerous() {
    this.getMaxConvertedLength() > this.getBufferSize()
  }

  override string getDescription() {
    result = "This conversion may yield a string of length "+this.getMaxConvertedLength().toString()+
             ", which exceeds the allocated buffer size of "+this.getBufferSize().toString()
  }
}

from PotentiallyDangerousFunctionCall c
where c.isDangerous()
select c, c.getDescription()
