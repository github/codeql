/**
 * @name Wrong usage of package unsafe
 * @description Casting between types with different memory sizes can produce reads to
 *              memory locations that are after the target buffer, and/or unexpected values.
 * @kind path-problem
 * @problem.severity error
 * @id go/wrong-usage-of-unsafe
 * @tags security
 *       experimental
 *       external/cwe/cwe-119
 *       external/cwe/cwe-126
 */

import go

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
  ConversionToUnsafePointer() { getFinalType(this.getResultType()) instanceof UnsafePointerType }
}

/* Type casting from a `unsafe.Pointer`.*/
module UnsafeTypeCastingConfig implements DataFlow::ConfigSig {
  additional predicate conversionIsSource(DataFlow::Node source, ConversionToUnsafePointer conv) {
    source = conv
  }

  additional predicate typeCastNodeIsSink(DataFlow::Node sink, DataFlow::TypeCastNode ca) {
    ca.getOperand().getType() instanceof UnsafePointerType and
    sink = ca
  }

  predicate isSource(DataFlow::Node source) { conversionIsSource(source, _) }

  predicate isSink(DataFlow::Node sink) { typeCastNodeIsSink(sink, _) }
}

/** Tracks taint flow for reasoning about type casting from a `unsafe.Pointer`. */
module UnsafeTypeCastingFlow = TaintTracking::Global<UnsafeTypeCastingConfig>;

import UnsafeTypeCastingFlow::PathGraph

/*
 * Type casting from a shorter array to a longer array
 * through the use of unsafe pointers.
 */

predicate castShortArrayToLongerArray(
  UnsafeTypeCastingFlow::PathNode source, UnsafeTypeCastingFlow::PathNode sink, string message
) {
  exists(
    DataFlow::TypeCastNode castBig, ConversionToUnsafePointer castLittle, ArrayType arrTo,
    ArrayType arrFrom, int arrFromSize
  |
    UnsafeTypeCastingFlow::flowPath(source, sink) and
    UnsafeTypeCastingConfig::conversionIsSource(source.getNode(), castLittle) and
    UnsafeTypeCastingConfig::typeCastNodeIsSink(sink.getNode(), castBig) and
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

predicate castTypeToArray(
  UnsafeTypeCastingFlow::PathNode source, UnsafeTypeCastingFlow::PathNode sink, string message
) {
  exists(
    DataFlow::TypeCastNode castBig, ConversionToUnsafePointer castLittle, ArrayType arrTo,
    Type typeFrom
  |
    UnsafeTypeCastingFlow::flowPath(source, sink) and
    UnsafeTypeCastingConfig::conversionIsSource(source.getNode(), castLittle) and
    UnsafeTypeCastingConfig::typeCastNodeIsSink(sink.getNode(), castBig) and
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
  UnsafeTypeCastingFlow::PathNode source, UnsafeTypeCastingFlow::PathNode sink, string message
) {
  exists(
    DataFlow::TypeCastNode castBig, ConversionToUnsafePointer castLittle, NumericType numTo,
    NumericType numFrom
  |
    UnsafeTypeCastingFlow::flowPath(source, sink) and
    UnsafeTypeCastingConfig::conversionIsSource(source.getNode(), castLittle) and
    UnsafeTypeCastingConfig::typeCastNodeIsSink(sink.getNode(), castBig) and
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

from UnsafeTypeCastingFlow::PathNode source, UnsafeTypeCastingFlow::PathNode sink, string message
where
  castShortArrayToLongerArray(source, sink, message) or
  castTypeToArray(source, sink, message) or
  castDifferentBitSizeNumbers(source, sink, message)
select sink.getNode(), source, sink, "$@.", source.getNode(), message
