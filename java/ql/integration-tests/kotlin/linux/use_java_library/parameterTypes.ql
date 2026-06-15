import java

class ExtLibParameter extends Parameter {
  ExtLibParameter() { this.getCallable().getName() = ["testParameterTypes", "takesSelfMethod"] }
}

query predicate parameterTypes(ExtLibParameter p, string t) { p.getType().toString() = t }

query predicate arrayTypes(
  ExtLibParameter p, Array at, string elementType, int dimension, string componentType
) {
  p.getType() = at and
  at.getElementType().toString() = elementType and
  at.getDimension() = dimension and
  at.getComponentType().toString() = componentType
}

query predicate wildcardTypes(ExtLibParameter p, Wildcard wc, string boundKind, string bound) {
  // Expose details of wildcard types:
  wc =
    [
      p.getType().(ParameterizedType).getATypeArgument(),
      p.getType().(ParameterizedType).getATypeArgument().(ParameterizedType).getATypeArgument()
    ] and
  (
    boundKind = "upper" and bound = wc.getUpperBoundType().toString()
    or
    boundKind = "lower" and bound = wc.getLowerBoundType().toString()
  )
}

query predicate parameterizedTypes(ExtLibParameter p, string ptstr, string typeArg) {
  exists(ParameterizedType pt |
    p.getType() = pt and
    pt.getATypeArgument().toString() = typeArg and
    ptstr = pt.toString()
  )
}

query predicate libCallables(Callable c) { c.getFile().getBaseName().matches("%Lib.java") }
