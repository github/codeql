private import codeql_ql.ast.internal.Type

predicate isBuiltinClassless(string sig) {
  sig =
    [
      "predicate any()", "predicate none()", "predicate toUrl(string, int, int, int, string)",
      "predicate toUrl(string, int, int, int, int, string)"
    ]
}

predicate isBuiltinClassless(string ret, string name, string args) {
  exists(string sig, string re | re = "(\\w+) (\\w+)\\(([\\w, ]*)\\)" |
    isBuiltinClassless(sig) and
    ret = sig.regexpCapture(re, 1) and
    name = sig.regexpCapture(re, 2) and
    args = sig.regexpCapture(re, 3)
  )
}

predicate isBuiltinMember(string sig) {
  sig =
    [
      "boolean boolean.booleanAnd(boolean)", "boolean boolean.booleanOr(boolean)",
      "boolean boolean.booleanXor(boolean)", "boolean boolean.booleanNot()",
      "string boolean.toString()", "float float.abs()", "float float.acos()", "float float.atan()",
      "int float.ceil()", "float float.copySign(float)", "float float.cos()", "float float.cosh()",
      "float float.exp()", "int float.floor()", "float float.log()", "float float.log(float)",
      "float float.log2()", "float float.log10()", "float float.maximum(float)",
      "float float.minimum(float)", "float float.nextAfter(float)", "float float.nextDown()",
      "float float.nextUp()", "float float.pow(float)", "float float.signum()", "float float.sin()",
      "float float.sinh()", "float float.sqrt()", "float float.tan()", "float float.tanh()",
      "string float.toString()", "float float.ulp()", "int int.abs()", "int int.bitAnd(int)",
      "int int.bitOr(int)", "int int.bitNot()", "int int.bitXor(int)", "int int.bitShiftLeft(int)",
      "int int.bitShiftRight(int)", "int int.bitShiftRightSigned(int)", "int int.gcd(int)",
      "string int.toString()", "string string.charAt(int)", "int string.indexOf(string)",
      "int string.indexOf(string, int, int)", "predicate string.isLowercase()",
      "predicate string.isUppercase()", "int string.length()", "predicate string.matches(string)",
      "string string.prefix(int)", "string string.regexpCapture(string, int)",
      "string string.regexpFind(string, int, int)", "predicate string.regexpMatch(string)",
      "string string.regexpReplaceAll(string, string)", "string string.replaceAll(string, string)",
      "string string.splitAt(string)", "string string.splitAt(string, int)",
      "string string.substring(int, int)", "string string.suffix(int)", "date string.toDate()",
      "float string.toFloat()", "int string.toInt()", "string string.toString()",
      "string string.toLowerCase()", "string string.toUpperCase()", "string string.trim()",
      "int date.daysTo(date)", "int date.getDay()", "int date.getHours()", "int date.getMinutes()",
      "int date.getMonth()", "int date.getSeconds()", "int date.getYear()",
      "string date.toString()", "string date.toISO()", "string int.toUnicode()",
      "string any.getAQlClass()"
      /* getAQlClass is special , see Predicate.qll*/
    ]
}

predicate isBuiltinMember(string qual, string ret, string name, string args) {
  exists(string sig, string re | re = "(\\w+) (\\w+)\\.(\\w+)\\(([\\w, ]*)\\)" |
    isBuiltinMember(sig) and
    ret = sig.regexpCapture(re, 1) and
    qual = sig.regexpCapture(re, 2) and
    name = sig.regexpCapture(re, 3) and
    args = sig.regexpCapture(re, 4)
  )
}

module BuiltinsConsistency {
  query predicate noBuiltinParse(string sig) {
    isBuiltinMember(sig) and
    not exists(sig.regexpCapture("(\\w+) (\\w+)\\.(\\w+)\\(([\\w, ]*)\\)", _))
  }

  query predicate noBuiltinClasslessParse(string sig) {
    isBuiltinClassless(sig) and
    not exists(sig.regexpCapture("(\\w+) (\\w+)\\(([\\w, ]*)\\)", _))
  }
}

bindingset[args]
string getArgType(string args, int i) { result = args.splitAt(",", i).trim() }

/** The primitive 'string' class. */
class StringClass extends PrimitiveType {
  StringClass() { this.getName() = "string" }
}

/** The primitive 'int' class. */
class IntClass extends PrimitiveType {
  IntClass() { this.getName() = "int" }
}

/** The primitive 'float' class. */
class FloatClass extends PrimitiveType {
  FloatClass() { this.getName() = "float" }
}

/** The primitive 'boolean' class. */
class BooleanClass extends PrimitiveType {
  BooleanClass() { this.getName() = "boolean" }
}

/**
 * Implements mocks for the built-in modules inside the `QlBuiltins` module.
 */
module QlBuiltinsMocks {
  private import AstMocks

  class QlBuiltinsModule extends MockModule::Range {
    QlBuiltinsModule() { this = "Mock: QlBuiltins" }

    override string getName() { result = "QlBuiltins" }

    override string getMember(int i) {
      i = 0 and
      result instanceof EquivalenceRelation::SigClass
      or
      i = 1 and
      result instanceof EquivalenceRelation::EdgeSig::EdgeSigModule
      or
      i = 2 and
      result instanceof EquivalenceRelation::EquivalenceRelationModule
      or
      i = 3 and
      result instanceof NewEntity::EntityKeySigClass
      or
      i = 4 and
      result instanceof NewEntity::NewEntityModule
    }
  }

  /**
   * A mock that implements the `EquivalenceRelation` module.
   * The equivalent to the following is implemented:
   * ```CodeQL
   * module QlBuiltins {
   *   signature class T;
   *   module EdgeSig<T MyT> { // This might not be needed.
   *     signature predicate edgeSig(MyT a, MyT b);
   *   }
   *   module EquivalenceRelation<T MyT, EdgeSig<MyT>::edgeSig/2 edge> { // the `edge` parameter is not modeled
   *     class EquivalenceClass;
   *     EquivalenceClass getEquivalenceClass(MyT a);
   *   }
   * }
   * ```
   */
  module EquivalenceRelation {
    class SigClass extends MockClass::Range {
      SigClass() { this = "Mock: QlBuiltins::T" }

      override string getName() { result = "T" }
    }

    /** A mock TypeExpr with classname `T`. Which we have 5 copies of. */
    class DummyTTypeExpr extends MockTypeExpr::Range {
      int n;

      DummyTTypeExpr() {
        this = "Mock: QlBuiltins::T(" + n + ")" and
        n = [0 .. 4]
      }

      override string getClassName() { result = "T" }

      int getN() { result = n }
    }

    module EdgeSig {
      class EdgeSigModule extends MockModule::Range {
        EdgeSigModule() { this = "Mock: QlBuiltins::EdgeSig" }

        override string getName() { result = "EdgeSig" }

        override predicate hasTypeParam(int i, string type, string name) {
          i = 0 and name = "MyT" and type.(DummyTTypeExpr).getN() = 0
        }

        override string getMember(int i) { i = 0 and result instanceof EdgeSigPred }
      }

      class EdgeSigPred extends MockClasslessPredicate::Range {
        EdgeSigPred() { this = "Mock: QlBuiltins::EdgeSig::edgeSig" }

        override string getName() { result = "edgeSig" }

        override EdgeSigPredParam getParameter(int i) {
          i = 0 and
          result.getName() = "a"
          or
          i = 1 and
          result.getName() = "b"
        }
      }

      class EdgeSigPredParam extends MockVarDecl::Range {
        string name;

        EdgeSigPredParam() {
          this = "Mock: QlBuiltins::EdgeSig::edgeSig::" + name and name = ["a", "b"]
        }

        override string getName() { result = name }

        override MockTypeExpr::Range getType() {
          name = "a" and result.(DummyTTypeExpr).getN() = 1
          or
          name = "b" and result.(DummyTTypeExpr).getN() = 2
        }
      }
    }

    class EquivalenceRelationModule extends MockModule::Range {
      EquivalenceRelationModule() { this = "Mock: QlBuiltins::EquivalenceRelation" }

      override string getName() { result = "EquivalenceRelation" }

      override string getMember(int i) {
        i = 0 and result instanceof EquivalenceClassClass
        or
        i = 1 and result instanceof GetEquivalenceClassPredicate
      }

      override predicate hasTypeParam(int i, string type, string name) {
        i = 0 and name = "MyT" and type.(DummyTTypeExpr).getN() = 3
        or
        none() // TODO: `EdgeSig<MyT>::edgeSig/2 edge` is not implemented.
      }
    }

    class GetEquivalenceClassPredicate extends MockClasslessPredicate::Range {
      GetEquivalenceClassPredicate() {
        this = "Mock: QlBuiltins::EquivalenceRelation::getEquivalenceClass"
      }

      override string getName() { result = "getEquivalenceClass" }

      override MockVarDecl::Range getParameter(int i) {
        result instanceof GetEquivalenceClassPredicateAParam and
        i = 0
      }

      override MockTypeExpr::Range getReturnTypeExpr() {
        result instanceof EquivalenceClassTypeExpr
      }
    }

    class GetEquivalenceClassPredicateAParam extends MockVarDecl::Range {
      GetEquivalenceClassPredicateAParam() {
        this = "Mock: QlBuiltins::EquivalenceRelation::getEquivalenceClass::a"
      }

      override string getName() { result = "a" }

      override MockTypeExpr::Range getType() { result.(DummyTTypeExpr).getN() = 4 }
    }

    class EquivalenceClassClass extends MockClass::Range {
      EquivalenceClassClass() {
        this = "Mock: QlBuiltins::EquivalenceRelation::EquivalenceClass(Class)"
      }

      override string getName() { result = "EquivalenceClass" }
    }

    class EquivalenceClassTypeExpr extends MockTypeExpr::Range {
      EquivalenceClassTypeExpr() {
        this = "Mock: QlBuiltins::EquivalenceRelation::EquivalenceClass(TypeExpr)"
      }

      override string getClassName() { result = "EquivalenceClass" }
    }
  }

  /**
   * A mock that implements the `NewEntity` module.
   * The equivalent to the following is implemented:
   * ```CodeQL
   * class EntityKeySig;
   * module NewEntity<EntityKeySig EntityKey> {
   *   class EntityId;
   *
   *   EntityId map(EntityKey key) { none() }
   * }
   * ```
   */
  module NewEntity {
    class EntityKeySigClass extends MockClass::Range {
      EntityKeySigClass() { this = "Mock: QlBuiltins::NewEntity::EntityKeySig" }

      override string getName() { result = "EntityKeySig" }
    }

    class NewEntityModule extends MockModule::Range {
      NewEntityModule() { this = "Mock: QlBuiltins::NewEntity" }

      override string getName() { result = "NewEntity" }

      override string getMember(int i) {
        i = 0 and result instanceof EntityIdClass
        or
        i = 1 and result instanceof NewEntityMapPredicate
      }

      ///  Holds if the `i`th type parameter has `type` (the ID of the mocked node) with `name`.
      override predicate hasTypeParam(int i, string type, string name) {
        i = 0 and
        name = "EntityKey" and
        type instanceof EntityKeySigTypeExpr
      }
    }

    class EntityKeySigTypeExpr extends MockTypeExpr::Range {
      EntityKeySigTypeExpr() { this = "Mock: QlBuiltins::NewEntity::EntityKey" }

      override string getClassName() { result = "EntityKeySig" }
    }

    class EntityIdClass extends MockClass::Range {
      EntityIdClass() { this = "Mock: QlBuiltins::NewEntity::EntityId" }

      override string getName() { result = "EntityId" }
    }

    class NewEntityMapPredicate extends MockClasslessPredicate::Range {
      NewEntityMapPredicate() { this = "Mock: QlBuiltins::NewEntity::map" }

      override string getName() { result = "map" }

      override string getParameter(int i) {
        i = 0 and
        result instanceof NewEntityMapPredicateParam
      }

      override MockTypeExpr::Range getReturnTypeExpr() {
        result.(NewEntityMapPredicateTypes).getClassName() = "EntityId"
      }
    }

    // both the TypeExprs used in the `map` predicate.
    class NewEntityMapPredicateTypes extends MockTypeExpr::Range {
      string type;

      NewEntityMapPredicateTypes() {
        type = ["EntityId", "EntityKey"] and
        this = "Mock: QlBuiltins::NewEntity::map::T#" + type
      }

      override string getClassName() { result = type }
    }

    class NewEntityMapPredicateParam extends MockVarDecl::Range {
      NewEntityMapPredicateParam() { this = "Mock: QlBuiltins::NewEntity::map::#0" }

      override string getName() { result = "key" }

      override MockTypeExpr::Range getType() {
        result.(NewEntityMapPredicateTypes).getClassName() = "EntityKey"
      }
    }
  }
}
