/**
 * Provides sanitizers that are applicable to several security queries.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow

/** Gets a reference to `name` from the `typing` or `typing_extensions` module. */
private API::Node typingRef(string name) {
  result = API::moduleImport(["typing", "typing_extensions"]).getMember(name)
}

/**
 * Gets a reference to a type whose instances cannot carry an injection payload.
 *
 * These are types with a closed, machine-generated string representation, such as
 * numbers, UUIDs, dates and enum members. A value of such a type can never contain
 * a line break, a quote, or a control character, and so cannot be used to forge a
 * log entry, break out of a query string, and so on.
 */
private API::Node simpleTypeRef() {
  result = API::builtin(["int", "float", "bool", "complex"])
  or
  result = API::moduleImport("uuid").getMember("UUID")
  or
  result = API::moduleImport("datetime").getMember(["date", "datetime", "time", "timedelta"])
  or
  result = API::moduleImport("decimal").getMember("Decimal")
  or
  result = API::moduleImport("ipaddress").getMember(["IPv4Address", "IPv6Address"])
  or
  // Pydantic aliases that validate to the corresponding stdlib type.
  // See https://docs.pydantic.dev/latest/api/types/
  result =
    API::moduleImport("pydantic")
        .getMember([
            "UUID1", "UUID3", "UUID4", "UUID5", "StrictBool", "StrictInt", "StrictFloat",
            "PositiveInt", "NegativeInt", "NonNegativeInt", "NonPositiveInt", "PositiveFloat",
            "NegativeFloat", "NonNegativeFloat", "NonPositiveFloat"
          ])
  or
  // The members of an enum are fixed when the class is defined, so an attacker can
  // at most select between values that already occur in the source code.
  result =
    API::moduleImport("enum")
        .getMember(["Enum", "IntEnum", "StrEnum", "Flag", "IntFlag"])
        .getASubclass+()
}

/**
 * Gets the type denoted by the parameter annotation `annotation`, looking through the
 * `Annotated[T, ...]`, `Optional[T]` and `T | None` wrappers that web frameworks accept.
 */
private Expr unwrapTypeAnnotation(Expr annotation) {
  annotation = any(Parameter p).getAnnotation() and
  result = annotation
  or
  exists(Expr inner | inner = unwrapTypeAnnotation(annotation) |
    // `Annotated[T, ...]`, where only the first element denotes the type.
    inner.(Subscript).getObject() =
      typingRef("Annotated").getAValueReachableFromSource().asExpr() and
    result = inner.(Subscript).getIndex().(Tuple).getElt(0)
    or
    // `Optional[T]`
    inner.(Subscript).getObject() =
      typingRef("Optional").getAValueReachableFromSource().asExpr() and
    result = inner.(Subscript).getIndex()
    or
    // `T | None`
    exists(BinaryExpr union | union = inner and union.getOp() instanceof BitOr |
      result = union.getLeft() and union.getRight() instanceof None
      or
      result = union.getRight() and union.getLeft() instanceof None
    )
  )
}

/**
 * A node whose value is of a simple type unlikely to carry taint, such as a number,
 * a `uuid.UUID`, a `datetime.datetime`, or an enum member.
 *
 * This is the Python counterpart of the `SimpleTypeSanitizer` classes used by the
 * Java and C# queries.
 *
 * Unlike in a statically typed language, a Python type annotation is not enforced at
 * run time, so an annotation is not trusted on its own. The annotation of a routed
 * parameter is trusted, however, since a web framework validates an incoming request
 * against it -- and rejects the request outright -- before the request handler body
 * runs.
 */
class SimpleTypeSanitizer extends DataFlow::Node {
  SimpleTypeSanitizer() {
    // A routed parameter whose annotation the web framework validates.
    exists(Parameter p |
      p = this.(DataFlow::ParameterNode).getParameter() and
      p = any(Http::Server::RequestHandler handler).getARoutedParameter() and
      unwrapTypeAnnotation(p.getAnnotation()) =
        simpleTypeRef().getAValueReachableFromSource().asExpr()
    )
    or
    // The result of converting a value to a simple type.
    this = simpleTypeRef().getACall()
    or
    this = API::builtin(["len", "hash", "id", "ord"]).getACall()
  }
}
