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

/*
 * Returns the type after all aliases, named types, and pointer
 * types have been replaced with the actual underlying type.
 */

Type getFinalType(Type typ) { result = getBaseType*(typ.getUnderlyingType()).getUnderlyingType() }

/*
 * Returns the base type of a PointerType;
 * if the provided type is not a pointer,
 * then the original type is returned.
 */

Type getBaseType(Type typ) {
  result = getBaseType*(typ.(PointerType).getBaseType*())
  or
  result = typ
}

/* A conversion to a `unsafe.Pointer` */
class ConversionToUnsafePointer extends DataFlow::TypeCastNode {
  ConversionToUnsafePointer() { getFinalType(getResultType()) instanceof UnsafePointerType }
}

/* Type casting from a `unsafe.Pointer`.*/
class UnsafeTypeCastingConf extends TaintTracking::Configuration {
  UnsafeTypeCastingConf() { this = "UnsafeTypeCastingConf" }

  predicate isSource(DataFlow::Node source, ConversionToUnsafePointer conv) { source = conv }

  predicate isSink(DataFlow::Node sink, DataFlow::TypeCastNode ca) {
    ca.getOperand().getType() instanceof UnsafePointerType and
    sink = ca
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
    UnsafeTypeCastingConf cfg, DataFlow::TypeCastNode castBig, ConversionToUnsafePointer castLittle,
    ArrayType arrTo, ArrayType arrFrom, int arrFromSize
  |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), castLittle) and
    cfg.isSink(sink.getNode(), castBig) and
    arrTo = getFinalType(castBig.getResultType()) and
    (
      // Array (whole) to array:
      // The `unsafe.Pointer` expression is on the array
      // (e.g. unsafe.Pointer(&someArray)),
      // meaning that the pointer points to the start of the array:
      arrFrom = getFinalType(castLittle.getOperand().getType()) and
      arrFromSize = arrFrom.getLength() and
      message = "Dangerous array type casting to " + arrTo.pp() + " from " + arrFrom.pp()
      or
      // Piece of array (starting from an index), to array:
      // The `unsafe.Pointer` expression can also point to a specific
      // element of an array
      // (e.g. unsafe.Pointer(&someArray[2])),
      // which will be the starting point in memory for the newly cast
      // variable.
      exists(DataFlow::ElementReadNode indexExpr |
        indexExpr = castLittle.getOperand().(DataFlow::AddressOperationNode).getOperand() and
        // The `arrFrom` is the base of the index expression:
        arrFrom = indexExpr.getBase().getType() and
        // Calculate the size of the `arrFrom`:
        arrFromSize = arrFrom.getLength() - indexExpr.getIndex().getIntValue() and
        message =
          "Dangerous array type casting to " + arrTo.pp() + " from an index expression (" +
            arrFrom.pp() + ")[" + indexExpr.getIndex().getIntValue() + "]" +
            " (the destination type is " + (arrTo.getLength() - arrFromSize) + " elements longer)"
      )
    ) and
    arrTo.getLength() > arrFromSize
  )
}

/*
 * Type casting from a type to an array
 * through the use of unsafe pointers.
 */

predicate castTypeToArray(DataFlow::PathNode source, DataFlow::PathNode sink, string message) {
  exists(
    UnsafeTypeCastingConf cfg, DataFlow::TypeCastNode castBig, ConversionToUnsafePointer castLittle,
    ArrayType arrTo, Type typeFrom
  |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), castLittle) and
    cfg.isSink(sink.getNode(), castBig) and
    arrTo = getFinalType(castBig.getResultType()) and
    not typeFrom.getUnderlyingType() instanceof ArrayType and
    not typeFrom instanceof PointerType and
    not castLittle
        .getOperand()
        .(DataFlow::AddressOperationNode)
        .getOperand()
        .(DataFlow::ElementReadNode)
        .getBase()
        .getType() instanceof ArrayType and
    typeFrom = getFinalType(castLittle.getOperand().getType()) and
    message = "Dangerous type up-casting to " + arrTo.pp() + " from " + typeFrom
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
    UnsafeTypeCastingConf cfg, DataFlow::TypeCastNode castBig, ConversionToUnsafePointer castLittle,
    NumericType numTo, NumericType numFrom
  |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), castLittle) and
    cfg.isSink(sink.getNode(), castBig) and
    numTo = getFinalType(castBig.getResultType()) and
    numFrom = getFinalType(castLittle.getOperand().getType()) and
    // TODO: also consider cast from uint to int?
    getNumericTypeSize(numTo) != getNumericTypeSize(numFrom) and
    // Exclude casts to UintptrType (which is still a pointer):
    not numTo instanceof UintptrType and
    message = "Dangerous numeric type casting to " + numTo.getName() + " from " + numFrom.getName()
  )
}

/*
 * Returns 0 if the NumericType is one of the numeric
 * types that have architecture-specific bit sizes.
 */

int getNumericTypeSize(NumericType typ) {
  // If the numeric types have arch-specific
  // bit sizes, then set the size to 0 to distinguish
  // it from others.
  not exists(typ.getSize()) and
  result = 0
  or
  result = typ.getSize()
}

from DataFlow::PathNode source, DataFlow::PathNode sink, string message
where
  castShortArrayToLongerArray(source, sink, message) or
  castTypeToArray(source, sink, message) or
  castDifferentBitSizeNumbers(source, sink, message)
select sink.getNode(), source, sink, "$@.", source.getNode(), message
