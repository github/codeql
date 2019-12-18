import cpp

/**
 * A function call that writes to a file
 */
class FileWrite extends Expr {
  FileWrite() { fileWrite(this, _, _) }

  Expr getASource() { fileWrite(this, result, _) }

  Expr getDest() { fileWrite(this, _, result) }
}

/**
 * A `std::basic_ostream` class, or something that can be used
 * as one.
 */
class BasicOStreamClass extends Type {
  BasicOStreamClass() {
    this.(Class).getName().matches("basic\\_ostream%")
    or
    this.getUnspecifiedType() instanceof BasicOStreamClass
    or
    this.(Class).getABaseClass() instanceof BasicOStreamClass
    or
    this.(ReferenceType).getBaseType() instanceof BasicOStreamClass
  }
}

/**
 * A call to a member of `std::basic_ostream`, or something related,
 * or a call with one of those objects as the first parameter.
 */
class BasicOStreamCall extends FunctionCall {
  BasicOStreamCall() {
    if getTarget() instanceof MemberFunction
    then getQualifier().getType() instanceof BasicOStreamClass
    else getArgument(0).getType() instanceof BasicOStreamClass
  }
}

/**
 * Output by a function that can be chained, such as `operator<<`.
 */
abstract class ChainedOutputCall extends BasicOStreamCall {
  /**
   * The source expression of this output.
   */
  abstract Expr getSource();

  /**
   * The immediate destination expression of this output.
   */
  abstract Expr getDest();

  /**
   * The destination at the far left-hand end of the output chain.
   */
  Expr getEndDest() {
    // recurse into the destination
    result = getDest().(ChainedOutputCall).getEndDest()
    or
    // or return something other than a ChainedOutputCall
    result = getDest() and
    not result instanceof ChainedOutputCall
  }
}

/**
 * A call to `operator<<` on an output stream.
 */
class OperatorLShiftCall extends ChainedOutputCall {
  OperatorLShiftCall() { getTarget().(Operator).hasName("operator<<") }

  override Expr getSource() {
    if getTarget() instanceof MemberFunction
    then result = getArgument(0)
    else result = getArgument(1)
  }

  override Expr getDest() {
    if getTarget() instanceof MemberFunction
    then result = getQualifier()
    else result = getArgument(0)
  }
}

/**
 * A call to 'put'.
 */
class PutFunctionCall extends ChainedOutputCall {
  PutFunctionCall() { getTarget().(MemberFunction).hasName("put") }

  override Expr getSource() { result = getArgument(0) }

  override Expr getDest() { result = getQualifier() }
}

/**
 * A call to 'write'.
 */
class WriteFunctionCall extends ChainedOutputCall {
  WriteFunctionCall() { getTarget().(MemberFunction).hasName("write") }

  override Expr getSource() { result = getArgument(0) }

  override Expr getDest() { result = getQualifier() }
}

/**
 * Whether the function call is a call to &lt;&lt; that eventually starts at the given file stream.
 */
private predicate fileStreamChain(ChainedOutputCall out, Expr source, Expr dest) {
  source = out.getSource() and
  dest = out.getEndDest() and
  exists(string nme | nme = "basic_ofstream" or nme = "basic_fstream" |
    dest.getUnderlyingType().(Class).getSimpleName() = nme
  )
}

/**
 * Whether the function call is a write to file 'dest' from 'source'.
 */
private predicate fileWrite(Call write, Expr source, Expr dest) {
  exists(Function f, int s, int d |
    f = write.getTarget() and source = write.getArgument(s) and dest = write.getArgument(d)
  |
    exists(string name | f.hasGlobalOrStdName(name) |
      // named functions
      name = "fwrite" and s = 0 and d = 3
      or
      (
        name = "fputs" or
        name = "fputws" or
        name = "fputc" or
        name = "fputwc" or
        name = "putc" or
        name = "putwc" or
        name = "putw"
      ) and
      s = 0 and
      d = 1
    )
    or
    // fprintf
    s >= f.(Fprintf).getFormatParameterIndex() and
    d = f.(Fprintf).getOutputParameterIndex()
  )
  or
  // file stream using '<<', 'put' or 'write'
  fileStreamChain(write, source, dest)
}
