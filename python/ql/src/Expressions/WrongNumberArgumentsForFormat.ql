/**
 * @name Wrong number of arguments for format
 * @description A string formatting operation, such as '"%s: %s, %s" % (a,b)', where the number of conversion specifiers in the
 *              format string differs from the number of values to be formatted will raise a TypeError.
 * @kind problem
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-685
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/percent-format/wrong-arguments
 */

import python
import semmle.python.strings

predicate string_format(BinaryExpr operation, StringLiteral str, Value args, AstNode origin) {
  operation.getOp() instanceof Mod and
  exists(Context ctx |
    operation.getLeft().pointsTo(ctx, _, str) and
    operation.getRight().pointsTo(ctx, args, origin)
  )
}

int sequence_length(Value args) {
  /* Guess length of sequence */
  exists(Tuple seq | seq.pointsTo(args, _) |
    result = strictcount(seq.getAnElt()) and
    not seq.getAnElt() instanceof Starred
  )
  or
  exists(ImmutableLiteral i | i.getLiteralValue() = args | result = 1)
}

from
  BinaryExpr operation, StringLiteral fmt, Value args, int slen, int alen, AstNode origin,
  string provided
where
  string_format(operation, fmt, args, origin) and
  slen = sequence_length(args) and
  alen = format_items(fmt) and
  slen != alen and
  (if slen = 1 then provided = " is provided." else provided = " are provided.")
select operation,
  "Wrong number of $@ for string format. Format $@ takes " + alen.toString() + ", but " +
    slen.toString() + provided, origin, "arguments", fmt, fmt.getText()
