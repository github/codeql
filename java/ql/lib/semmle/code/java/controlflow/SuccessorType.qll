import java
private import codeql.util.Boolean

private newtype TSuccessorType =
  TNormalSuccessor() or
  TBooleanSuccessor(Boolean branch) or
  TExceptionSuccessor()

class SuccessorType extends TSuccessorType {
  string toString() { result = "SuccessorType" }
}

class NormalSuccessor extends SuccessorType, TNormalSuccessor { }

class ExceptionSuccessor extends SuccessorType, TExceptionSuccessor { }

class ConditionalSuccessor extends SuccessorType, TBooleanSuccessor {
  boolean getValue() { this = TBooleanSuccessor(result) }
}

class BooleanSuccessor = ConditionalSuccessor;

class NullnessSuccessor extends ConditionalSuccessor {
  NullnessSuccessor() { none() }
}
