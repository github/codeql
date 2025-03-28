/**
 * Provides the `Content` class and subclasses thereof.
 */

private import rust
private import codeql.rust.controlflow.CfgNodes
private import DataFlowImpl

/**
 * A path to a value contained in an object. For example a field name of a struct.
 */
abstract class Content extends TContent {
  /** Gets a textual representation of this content. */
  abstract string toString();

  /** Gets the location of this content. */
  abstract Location getLocation();
}

/** A field belonging to either a variant or a struct. */
abstract class FieldContent extends Content {
  /** Gets an access to this field. */
  pragma[nomagic]
  abstract FieldExprCfgNode getAnAccess();
}

/** A tuple field belonging to either a variant or a struct. */
class TupleFieldContent extends FieldContent, TTupleFieldContent {
  private TupleField field;

  TupleFieldContent() { this = TTupleFieldContent(field) }

  /** Holds if this field belongs to an enum variant. */
  predicate isVariantField(Variant v, int pos) { field.isVariantField(v, pos) }

  /** Holds if this field belongs to a struct. */
  predicate isStructField(Struct s, int pos) { field.isStructField(s, pos) }

  override FieldExprCfgNode getAnAccess() { field = result.getFieldExpr().getTupleField() }

  final override string toString() {
    exists(Variant v, int pos, string vname |
      this.isVariantField(v, pos) and
      vname = v.getName().getText() and
      // only print indices when the arity is > 1
      if exists(v.getTupleField(1)) then result = vname + "(" + pos + ")" else result = vname
    )
    or
    exists(Struct s, int pos, string sname |
      this.isStructField(s, pos) and
      sname = s.getName().getText() and
      // only print indices when the arity is > 1
      if exists(s.getTupleField(1)) then result = sname + "(" + pos + ")" else result = sname
    )
  }

  final override Location getLocation() { result = field.getLocation() }
}

/** A record field belonging to either a variant or a struct. */
class StructFieldContent extends FieldContent, TStructFieldContent {
  private StructField field;

  StructFieldContent() { this = TStructFieldContent(field) }

  /** Holds if this field belongs to an enum variant. */
  predicate isVariantField(Variant v, string name) { field.isVariantField(v, name) }

  /** Holds if this field belongs to a struct. */
  predicate isStructField(Struct s, string name) { field.isStructField(s, name) }

  override FieldExprCfgNode getAnAccess() { field = result.getFieldExpr().getStructField() }

  final override string toString() {
    exists(Variant v, string name, string vname |
      this.isVariantField(v, name) and
      vname = v.getName().getText() and
      // only print field when the arity is > 1
      if strictcount(v.getStructField(_)) > 1 then result = vname + "." + name else result = vname
    )
    or
    exists(Struct s, string name, string sname |
      this.isStructField(s, name) and
      sname = s.getName().getText() and
      // only print field when the arity is > 1
      if strictcount(s.getStructField(_)) > 1 then result = sname + "." + name else result = sname
    )
  }

  final override Location getLocation() { result = field.getLocation() }
}

/** A captured variable. */
final class CapturedVariableContent extends Content, TCapturedVariableContent {
  private Variable v;

  CapturedVariableContent() { this = TCapturedVariableContent(v) }

  /** Gets the captured variable. */
  Variable getVariable() { result = v }

  override string toString() { result = "captured " + v }

  override Location getLocation() { result = v.getLocation() }
}

/** A value referred to by a reference. */
final class ReferenceContent extends Content, TReferenceContent {
  override string toString() { result = "&ref" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * An element in a collection where we do not track the specific collection
 * type nor the placement of the element in the collection. Therefore the
 * collection should be one where the elements are reasonably homogeneous,
 * i.e., if one is tainted all elements are considered tainted.
 *
 * Examples include the elements of a set, array, vector, or stack.
 */
final class ElementContent extends Content, TElementContent {
  override string toString() { result = "element" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A value that a future resolves to.
 */
final class FutureContent extends Content, TFutureContent {
  override string toString() { result = "future" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * Content stored at a position in a tuple.
 *
 * NOTE: Unlike `struct`s and `enum`s tuples are structural and not nominal,
 * hence we don't store a canonical path for them.
 */
final class TuplePositionContent extends FieldContent, TTuplePositionContent {
  private int pos;

  TuplePositionContent() { this = TTuplePositionContent(pos) }

  /** Gets the index of this tuple position. */
  int getPosition() { result = pos }

  override FieldExprCfgNode getAnAccess() {
    // TODO: limit to tuple types
    result.getIdentifier().getText().toInt() = pos
  }

  override string toString() { result = "tuple." + pos.toString() }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A content for the index of an argument to at function call.
 *
 * Used by the model generator to create flow summaries for higher-order
 * functions.
 */
final class FunctionCallArgumentContent extends Content, TFunctionCallArgumentContent {
  private int pos;

  FunctionCallArgumentContent() { this = TFunctionCallArgumentContent(pos) }

  int getPosition() { result = pos }

  override string toString() { result = "function argument at " + pos }

  override Location getLocation() { result instanceof EmptyLocation }
}

/**
 * A content for the return value of function call.
 *
 * Used by the model generator to create flow summaries for higher-order
 * functions.
 */
final class FunctionCallReturnContent extends Content, TFunctionCallReturnContent {
  override string toString() { result = "function return" }

  override Location getLocation() { result instanceof EmptyLocation }
}

/** A value that represents a set of `Content`s. */
abstract class ContentSet extends TContentSet {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets a content that may be stored into when storing into this set. */
  abstract Content getAStoreContent();

  /** Gets a content that may be read from when reading from this set. */
  abstract Content getAReadContent();
}

final class SingletonContentSet extends ContentSet, TSingletonContentSet {
  private Content c;

  SingletonContentSet() { this = TSingletonContentSet(c) }

  Content getContent() { result = c }

  override string toString() { result = c.toString() }

  override Content getAStoreContent() { result = c }

  override Content getAReadContent() { result = c }
}

/**
 * A step in a flow summary defined using `OptionalStep[name]`. An `OptionalStep` is "opt-in", which means
 * that by default the step is not present in the flow summary and needs to be explicitly enabled by defining
 * an additional flow step.
 */
final class OptionalStep extends ContentSet, TOptionalStep {
  override string toString() {
    exists(string name |
      this = TOptionalStep(name) and
      result = "OptionalStep[" + name + "]"
    )
  }

  override Content getAStoreContent() { none() }

  override Content getAReadContent() { none() }
}

/**
 * A step in a flow summary defined using `OptionalBarrier[name]`. An `OptionalBarrier` is "opt-out", by default
 * data can flow freely through the step. Flow through the step can be explicity blocked by defining its node as a barrier.
 */
final class OptionalBarrier extends ContentSet, TOptionalBarrier {
  override string toString() {
    exists(string name |
      this = TOptionalBarrier(name) and
      result = "OptionalBarrier[" + name + "]"
    )
  }

  override Content getAStoreContent() { none() }

  override Content getAReadContent() { none() }
}

private import codeql.rust.internal.CachedStages

cached
newtype TContent =
  TTupleFieldContent(TupleField field) { Stages::DataFlowStage::ref() } or
  TStructFieldContent(StructField field) or
  // TODO: Remove once library types are extracted
  TVariantInLibTupleFieldContent(VariantInLib::VariantInLib v, int pos) { pos = v.getAPosition() } or
  TElementContent() or
  TFutureContent() or
  TTuplePositionContent(int pos) {
    pos in [0 .. max([
              any(TuplePat pat).getNumberOfFields(),
              any(FieldExpr access).getIdentifier().getText().toInt()
            ]
        )]
  } or
  TFunctionCallReturnContent() or
  TFunctionCallArgumentContent(int pos) {
    pos in [0 .. any(CallExpr c).getArgList().getNumberOfArgs() - 1]
  } or
  TCapturedVariableContent(VariableCapture::CapturedVariable v) or
  TReferenceContent()
