/**
 * Provides classes modeling relevant aspects of the standard libraries.
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSummary
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.typeinference.Type
private import codeql.rust.internal.typeinference.TypeMention

/**
 * A call to the `starts_with` method on a `Path`.
 */
private class StartswithCall extends Path::SafeAccessCheck::Range, MethodCall {
  StartswithCall() { this.getStaticTarget().getCanonicalPath() = "<std::path::Path>::starts_with" }

  override predicate checks(Expr e, boolean branch) {
    e = this.getReceiver() and
    branch = true
  }
}

/**
 * A flow summary for the [reflexive implementation of the `From` trait][1].
 *
 * Blanket implementations currently don't have a canonical path, so we cannot
 * use models-as-data for this model.
 *
 * [1]: https://doc.rust-lang.org/std/convert/trait.From.html#impl-From%3CT%3E-for-T
 */
private class ReflexiveFrom extends SummarizedCallable::Range {
  ReflexiveFrom() {
    exists(ImplItemNode impl |
      impl.resolveTraitTy().(Trait).getCanonicalPath() = "core::convert::From" and
      this = impl.getAssocItem("from") and
      resolvePath(this.getParam(0).getTypeRepr().(PathTypeRepr).getPath()) =
        impl.getBlanketImplementationTypeParam()
    )
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance p, boolean isExact, string model
  ) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true and
    p = "manual" and
    isExact = true and
    model = "ReflexiveFrom"
  }
}

/**
 * The [`Option` enum][1].
 *
 * [1]: https://doc.rust-lang.org/std/option/enum.Option.html
 */
class OptionEnum extends Enum {
  pragma[nomagic]
  OptionEnum() { this.getCanonicalPath() = "core::option::Option" }

  /** Gets the `Some` variant. */
  Variant getSome() { result = this.getVariant("Some") }
}

/**
 * The [`Result` enum][1].
 *
 * [1]: https://doc.rust-lang.org/stable/std/result/enum.Result.html
 */
class ResultEnum extends Enum {
  pragma[nomagic]
  ResultEnum() { this.getCanonicalPath() = "core::result::Result" }

  /** Gets the `Ok` variant. */
  Variant getOk() { result = this.getVariant("Ok") }

  /** Gets the `Err` variant. */
  Variant getErr() { result = this.getVariant("Err") }
}

/**
 * The [`Range` struct][1].
 *
 * [1]: https://doc.rust-lang.org/core/ops/struct.Range.html
 */
class RangeStruct extends Struct {
  pragma[nomagic]
  RangeStruct() { this.getCanonicalPath() = "core::ops::range::Range" }

  /** Gets the `start` field. */
  StructField getStart() { result = this.getStructField("start") }

  /** Gets the `end` field. */
  StructField getEnd() { result = this.getStructField("end") }
}

/**
 * The [`RangeFrom` struct][1].
 *
 * [1]: https://doc.rust-lang.org/core/ops/struct.RangeFrom.html
 */
class RangeFromStruct extends Struct {
  pragma[nomagic]
  RangeFromStruct() { this.getCanonicalPath() = "core::ops::range::RangeFrom" }

  /** Gets the `start` field. */
  StructField getStart() { result = this.getStructField("start") }
}

/**
 * The [`RangeTo` struct][1].
 *
 * [1]: https://doc.rust-lang.org/core/ops/struct.RangeTo.html
 */
class RangeToStruct extends Struct {
  pragma[nomagic]
  RangeToStruct() { this.getCanonicalPath() = "core::ops::range::RangeTo" }

  /** Gets the `end` field. */
  StructField getEnd() { result = this.getStructField("end") }
}

/**
 * The [`RangeFull` struct][1].
 *
 * [1]: https://doc.rust-lang.org/core/ops/struct.RangeFull.html
 */
class RangeFullStruct extends Struct {
  pragma[nomagic]
  RangeFullStruct() { this.getCanonicalPath() = "core::ops::range::RangeFull" }
}

/**
 * The [`RangeInclusive` struct][1].
 *
 * [1]: https://doc.rust-lang.org/core/ops/struct.RangeInclusive.html
 */
class RangeInclusiveStruct extends Struct {
  pragma[nomagic]
  RangeInclusiveStruct() { this.getCanonicalPath() = "core::ops::range::RangeInclusive" }

  /** Gets the `start` field. */
  StructField getStart() { result = this.getStructField("start") }

  /** Gets the `end` field. */
  StructField getEnd() { result = this.getStructField("end") }
}

/**
 * The [`RangeToInclusive` struct][1].
 *
 * [1]: https://doc.rust-lang.org/core/ops/struct.RangeToInclusive.html
 */
class RangeToInclusiveStruct extends Struct {
  pragma[nomagic]
  RangeToInclusiveStruct() { this.getCanonicalPath() = "core::ops::range::RangeToInclusive" }

  /** Gets the `end` field. */
  StructField getEnd() { result = this.getStructField("end") }
}

/**
 * The [`Future` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/future/trait.Future.html
 */
class FutureTrait extends Trait {
  pragma[nomagic]
  FutureTrait() { this.getCanonicalPath() = "core::future::future::Future" }

  /** Gets the `Output` associated type. */
  pragma[nomagic]
  TypeAlias getOutputType() { result = this.(TraitItemNode).getAssocItem("Output") }
}

/** A function trait `FnOnce`, `FnMut`, or `Fn`. */
abstract private class AnyFnTraitImpl extends Trait {
  /** Gets the `Args` type parameter of this trait. */
  TypeParam getTypeParam() { result = this.getGenericParamList().getGenericParam(0) }
}

final class AnyFnTrait = AnyFnTraitImpl;

/**
 * The [`FnOnce` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html
 */
class FnOnceTrait extends AnyFnTraitImpl {
  pragma[nomagic]
  FnOnceTrait() { this.getCanonicalPath() = "core::ops::function::FnOnce" }

  /** Gets the `Output` associated type. */
  pragma[nomagic]
  TypeAlias getOutputType() { result = this.(TraitItemNode).getAssocItem("Output") }
}

/**
 * The [`FnMut` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 */
class FnMutTrait extends AnyFnTraitImpl {
  pragma[nomagic]
  FnMutTrait() { this.getCanonicalPath() = "core::ops::function::FnMut" }
}

/**
 * The [`Fn` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 */
class FnTrait extends AnyFnTraitImpl {
  pragma[nomagic]
  FnTrait() { this.getCanonicalPath() = "core::ops::function::Fn" }
}

/**
 * The [`Iterator` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/iter/trait.Iterator.html
 */
class IteratorTrait extends Trait {
  pragma[nomagic]
  IteratorTrait() { this.getCanonicalPath() = "core::iter::traits::iterator::Iterator" }

  /** Gets the `Item` associated type. */
  pragma[nomagic]
  TypeAlias getItemType() { result = this.(TraitItemNode).getAssocItem("Item") }
}

/**
 * The [`IntoIterator` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/iter/trait.IntoIterator.html
 */
class IntoIteratorTrait extends Trait {
  pragma[nomagic]
  IntoIteratorTrait() { this.getCanonicalPath() = "core::iter::traits::collect::IntoIterator" }

  /** Gets the `Item` associated type. */
  pragma[nomagic]
  TypeAlias getItemType() { result = this.(TraitItemNode).getAssocItem("Item") }
}

/**
 * The [`String` struct][1].
 *
 * [1]: https://doc.rust-lang.org/std/string/struct.String.html
 */
class StringStruct extends Struct {
  pragma[nomagic]
  StringStruct() { this.getCanonicalPath() = "alloc::string::String" }
}

/**
 * The [`Deref` trait][1].
 *
 * [1]: https://doc.rust-lang.org/core/ops/trait.Deref.html
 */
class DerefTrait extends Trait {
  pragma[nomagic]
  DerefTrait() { this.getCanonicalPath() = "core::ops::deref::Deref" }

  /** Gets the `deref` function. */
  Function getDerefFunction() { result = this.(TraitItemNode).getAssocItem("deref") }

  /** Gets the `Target` associated type. */
  pragma[nomagic]
  TypeAlias getTargetType() { result = this.(TraitItemNode).getAssocItem("Target") }
}

/**
 * The [`Index` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/ops/trait.Index.html
 */
class IndexTrait extends Trait {
  pragma[nomagic]
  IndexTrait() { this.getCanonicalPath() = "core::ops::index::Index" }

  /** Gets the `index` function. */
  Function getIndexFunction() { result = this.(TraitItemNode).getAssocItem("index") }

  /** Gets the `Output` associated type. */
  pragma[nomagic]
  TypeAlias getOutputType() { result = this.(TraitItemNode).getAssocItem("Output") }
}

/**
 * The [`IndexMut` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/ops/trait.IndexMut.html
 */
class IndexMutTrait extends Trait {
  pragma[nomagic]
  IndexMutTrait() { this.getCanonicalPath() = "core::ops::index::IndexMut" }

  /** Gets the `index_mut` function. */
  Function getIndexMutFunction() { result = this.(TraitItemNode).getAssocItem("index_mut") }
}

/**
 * The [`Box` struct][1].
 *
 * [1]: https://doc.rust-lang.org/std/boxed/struct.Box.html
 */
class BoxStruct extends Struct {
  pragma[nomagic]
  BoxStruct() { this.getCanonicalPath() = "alloc::boxed::Box" }
}

/**
 * The [`Rc` struct][1].
 *
 * [1]: https://doc.rust-lang.org/std/rc/struct.Rc.html
 */
class RcStruct extends Struct {
  pragma[nomagic]
  RcStruct() { this.getCanonicalPath() = "alloc::rc::Rc" }
}

/**
 * The [`Arc` struct][1].
 *
 * [1]: https://doc.rust-lang.org/std/sync/struct.Arc.html
 */
class ArcStruct extends Struct {
  pragma[nomagic]
  ArcStruct() { this.getCanonicalPath() = "alloc::sync::Arc" }
}

/**
 * The [`Pin` struct][1].
 *
 * [1]: https://doc.rust-lang.org/std/pin/struct.Pin.html
 */
class PinStruct extends Struct {
  pragma[nomagic]
  PinStruct() { this.getCanonicalPath() = "core::pin::Pin" }
}

/**
 * The [`Vec` struct][1].
 *
 * [1]: https://doc.rust-lang.org/alloc/vec/struct.Vec.html
 */
class Vec extends Struct {
  pragma[nomagic]
  Vec() { this.getCanonicalPath() = "alloc::vec::Vec" }

  /** Gets the type parameter representing the element type. */
  TypeParam getElementTypeParam() { result = this.getGenericParamList().getTypeParam(0) }
}
