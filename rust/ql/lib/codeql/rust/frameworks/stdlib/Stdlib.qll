/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.PathResolution

/**
 * A call to the `starts_with` method on a `Path`.
 */
private class StartswithCall extends Path::SafeAccessCheck::Range, CfgNodes::MethodCallExprCfgNode {
  StartswithCall() {
    this.getMethodCallExpr().getStaticTarget().getCanonicalPath() = "<std::path::Path>::starts_with"
  }

  override predicate checks(Cfg::CfgNode e, boolean branch) {
    e = this.getReceiver() and
    branch = true
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
  TypeAlias getOutputType() {
    result = this.getAssocItemList().getAnAssocItem() and
    result.getName().getText() = "Output"
  }
}

/**
 * The [`FnOnce` trait][1].
 *
 * [1]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html
 */
class FnOnceTrait extends Trait {
  pragma[nomagic]
  FnOnceTrait() { this.getCanonicalPath() = "core::ops::function::FnOnce" }

  /** Gets the type parameter of this trait. */
  TypeParam getTypeParam() { result = this.getGenericParamList().getGenericParam(0) }

  /** Gets the `Output` associated type. */
  pragma[nomagic]
  TypeAlias getOutputType() {
    result = this.getAssocItemList().getAnAssocItem() and
    result.getName().getText() = "Output"
  }
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
  TypeAlias getItemType() {
    result = this.getAssocItemList().getAnAssocItem() and
    result.getName().getText() = "Item"
  }
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
  TypeAlias getItemType() {
    result = this.getAssocItemList().getAnAssocItem() and
    result.getName().getText() = "Item"
  }
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
  TypeAlias getTargetType() {
    result = this.getAssocItemList().getAnAssocItem() and
    result.getName().getText() = "Target"
  }
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
  TypeAlias getOutputType() {
    result = this.getAssocItemList().getAnAssocItem() and
    result.getName().getText() = "Output"
  }
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
