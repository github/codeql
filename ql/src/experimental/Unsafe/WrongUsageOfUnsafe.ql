/**
 * @name Wrong usage of package unsafe
 * @description Casting between types with different memory sizes can produce reads to
 *              memory locations that are after the target buffer, and/or unexpected values.
 * @kind path-problem
 * @problem.severity error
 * @id go/wrong-usage-of-unsafe
 * @tags security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-126
 */

import go
import DataFlow::PathGraph

Type getBaseType(Type typ) {
  result =
    getBaseType*(typ.getUnderlyingType*().(PointerType).getBaseType*().getUnderlyingType*())
        .getUnderlyingType*()
  or
  result = typ
}

/* A conversion to a `unsafe.Pointer` */
class ConversionToUnsafePointer extends ConversionExpr {
  ConversionToUnsafePointer() { getBaseType(getType()) instanceof UnsafePointerType }
}

/* Type casting through the use of unsafe pointers.*/
class UnsafeTypeCastingConf extends TaintTracking::Configuration {
  UnsafeTypeCastingConf() { this = "UnsafeTypeCastingConf" }

  predicate isSource(DataFlow::Node source, ConversionToUnsafePointer conv) {
    source.asExpr() = conv
  }

  predicate isSink(DataFlow::Node sink, ConversionExpr ca) {
    ca.getOperand().getType() instanceof UnsafePointerType and
    sink.asExpr() = ca
  }

  override predicate isSource(DataFlow::Node source) { isSource(source, _) }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

/*
 * Type casting from a shorter array to a longer array
 * through the use of unsafe pointers.
 */

predicate castShortArrayToLongerArray(
  DataFlow::PathNode source, DataFlow::PathNode sink, string message
) {
  exists(
    UnsafeTypeCastingConf cfg, ConversionExpr castBig, ConversionToUnsafePointer castLittle,
    ArrayType arrTo, ArrayType arrFrom
  |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), castLittle) and
    cfg.isSink(sink.getNode(), castBig) and
    arrTo = getBaseType(castBig.getTypeExpr().getType()) and
    (
      arrFrom = getBaseType(castLittle.getOperand().getType())
      or
      arrFrom = castLittle.getOperand().getChildExpr(0).(IndexExpr).getBase().getType()
    ) and
    arrTo.getLength() > 0 and //TODO
    arrTo.getLength() > arrFrom.getLength() and
    message =
      "Dangerous array type casting to [" + arrTo.getLength() + "]" + arrTo.getElementType() +
        " from [" + arrFrom.getLength() + "]" + arrFrom.getElementType()
  )
}

/*
 * Type casting from a type to an array
 * through the use of unsafe pointers.
 */

predicate castTypeToArray(DataFlow::PathNode source, DataFlow::PathNode sink, string message) {
  exists(
    UnsafeTypeCastingConf cfg, ConversionExpr castBig, ConversionToUnsafePointer castLittle,
    ArrayType arrTo, Type typeFrom
  |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), castLittle) and
    cfg.isSink(sink.getNode(), castBig) and
    arrTo = getBaseType(castBig.getTypeExpr().getType()) and
    not (typeFrom instanceof ArrayType or typeFrom.getUnderlyingType() instanceof ArrayType) and
    not typeFrom instanceof PointerType and
    not castLittle.getOperand().getChildExpr(0).(IndexExpr).getBase().getType() instanceof ArrayType and
    typeFrom = getBaseType(castLittle.getOperand().getType()) and
    message =
      "Dangerous type up-casting to [" + arrTo.getLength() + "]" + arrTo.getElementType() + " from "
        + typeFrom
  )
}

/*
 * Type casting between numeric types that have different bit sizes
 * through the use of unsafe pointers.
 */

predicate castDifferentBitSizeNumbers(
  DataFlow::PathNode source, DataFlow::PathNode sink, string message
) {
  exists(
    UnsafeTypeCastingConf cfg, ConversionExpr castBig, ConversionToUnsafePointer castLittle,
    CustomNumericType numTo, CustomNumericType numFrom
  |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), castLittle) and
    cfg.isSink(sink.getNode(), castBig) and
    numTo = getBaseType(castBig.getTypeExpr().getType()) and
    (
      numFrom = getBaseType(castLittle.getOperand().getType()) or
      numFrom =
        getBaseType(getBaseType(castLittle.getOperand().getType())
              .(StructType)
              .getField(_)
              .getType())
    ) and
    // TODO: also consider cast from uint to int?
    numTo.getSize() != numFrom.getSize() and
    message = "Dangerous numeric type casting to " + numTo.getName() + " from " + numFrom.getName()
  )
}

/*
 * A numeric type that returns bit size 0 if it is one of the numeric
 * types that have architecture-specific bit sizes.
 */

class CustomNumericType extends NumericType {
  CustomNumericType() { this instanceof NumericType }

  override int getSize() {
    (
      // If the numeric types have arch-specific
      // bit sizes, then set the size to 0 to distinguish
      // it from others.
      this instanceof UintType
      or
      this instanceof IntType
    ) and
    result = 0
    or
    result = this.(NumericType).getSize()
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, string message
where
  castShortArrayToLongerArray(source, sink, message) or
  castTypeToArray(source, sink, message) or
  castDifferentBitSizeNumbers(source, sink, message)
select sink.getNode(), source, sink, "$@.", source.getNode(), message
