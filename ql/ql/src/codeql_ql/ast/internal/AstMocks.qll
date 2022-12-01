/**
 * Implements AST mocks.
 *
 * Everything is mostly implemented using magic strings, because we don't have
 * bindingsets on IPA types.
 * Those strings have to be unique, even across different types of mock AST nodes.
 */

private import codeql_ql.ast.internal.AstNodes
private import codeql.util.Unit
private import codeql.util.Either

// Three good reasons for doing an IPA type instead of just a string directly:
// 1: Better type checking with distinct types.
// 2: We don't get all the methods defined on strings, to confuse us.
// 3: The Either type gets a type without bindingset on the charpred/toString.
newtype TMockAst =
  TMockModule(string id) { id instanceof MockModule::Range } or
  TMockClass(string id) { id instanceof MockClass::Range }

/** Gets a mocked Ast node from the string ID that represents it. */
MockAst fromId(string id) {
  result = TMockModule(id)
  or
  result = TMockClass(id)
  // TODO: Other nodes.
}

/** A mocked AST node. */
class MockAst extends TMockAst {
  string toString() { fromId(result) = this }

  string getId() { result = this.toString() }
}

/**
 * A mocked module.
 * Extend `MockModule::Range` to add new mocked modules.
 */
class MockModule extends MockAst, TMockModule {
  MockModule::Range range;

  MockModule() { this = TMockModule(range) }

  final string getName() { result = range.getName() }

  /** Gets the `i`th mocked child of this module. */
  final MockAst getMember(int i) { result = fromId(range.getMember(i)) }

  final predicate hasTypeParam(int i, MockAst type, string name) {
    range.hasTypeParam(i, type.toString(), name)
  }
}

module MockModule {
  abstract class Range extends string {
    bindingset[this]
    Range() { this = this }

    /** Gets tthe name of this mocked module. */
    abstract string getName();

    /** Gets the id for the `i`th mocked member of this module. */
    abstract string getMember(int i);

    /** Holds if the `i`th type parameter has `type` (the ID of the mocked node) with `name`. */
    predicate hasTypeParam(int i, string type, string name) {
      none() // may be overridden in subclasses
    }
  }
}

class ModuleOrMock = Either<QL::Module, MockModule>::Either;

/**
 * A mocked class.
 * Extend `MockClass::Range` to add new mocked classes.
 */
class MockClass extends MockAst, TMockClass {
  MockClass::Range range;

  MockClass() { this = TMockClass(range) }

  final string getName() { result = range.getName() }
}

module MockClass {
  abstract class Range extends string {
    bindingset[this]
    Range() { this = this }

    /** Gets the name of this mocked class. */
    abstract string getName();
  }
}

class ClassOrMock = Either<QL::Dataclass, MockClass>::Either;
