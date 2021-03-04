/**
 * @name Use detect
 * @description Use 'detect' instead of 'first' and 'last'.
 * @kind problem
 * @problem.severity warning
 * @id rb/use-detect
 * @tags performance rubocop
 * @precision high
 *
 * This is an implementation of Rubocop rule
 * https://github.com/rubocop/rubocop-performance/blob/master/lib/rubocop/cop/performance/detect.rb
 */

import ruby

// Extracts the first or last element of a list
abstract class EndCall extends MethodCall {
  abstract string detectCall();
}

abstract class First extends EndCall {
  override string detectCall() { result = "detect" }
}

class FirstCall extends First {
  FirstCall() {
    this.getMethodName() = "first" and
    this.getNumberOfArguments() = 0
  }
}

class FirstElement extends First, ElementReference {
  FirstElement() {
    this.getNumberOfArguments() = 1 and
    this.getArgument(0).(IntegerLiteral).getValueText() = "0"
  }
}

abstract class Last extends EndCall {
  override string detectCall() { result = "reverse_detect" }
}

class LastCall extends Last {
  LastCall() { this.getMethodName() = "last" and this.getNumberOfArguments() = 0 }
}

class LastElement extends Last, ElementReference {
  LastElement() {
    this.getNumberOfArguments() = 1 and
    this.getArgument(0).(UnaryMinusExpr).getOperand().(IntegerLiteral).getValueText() = "1"
  }
}

class SelectBlock extends MethodCall {
  SelectBlock() {
    this.getMethodName() in ["select", "filter", "find_all"] and
    exists(this.getBlock())
  }
}

from EndCall call, SelectBlock selectBlock
where selectBlock = call.getReceiver()
select call, "Replace this call with '" + call.detectCall() + "'."
