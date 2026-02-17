/**
 * @name Year field changed using an arithmetic operation without checking for leap year
 * @description A field that represents a year is being modified by an arithmetic operation, but no proper check for leap years can be detected afterwards.
 * @kind path-problem
 * @problem.severity warning
 * @id cpp/leap-year/unchecked-after-arithmetic-year-modification
 * @precision medium
 * @tags leap-year
 *       correctness
 */

import cpp
import LeapYear
import semmle.code.cpp.controlflow.IRGuards

/**
 * Functions whose operations should never be considered a
 * source or sink of a dangerous leap year operation.
 * The general concept is to add conversion functions
 * that convert one time type to another. Often
 * other ignorable operation heuristics will filter these,
 * but some cases, the simplest approach is to simply filter
 * the function entirely.
 * Note that flow through these functions should still be allowed
 * we just cannot start or end flow from an operation to a
 * year assignment in one of these functions.
 */
class IgnorableFunction extends Function {
  IgnorableFunction() {
    // arithmetic in known time conversion functions may look like dangerous operations
    // we assume all known time conversion functions are safe.
    this instanceof TimeConversionFunction
    or
    // Helper utility in postgres with string time conversions
    this.getName() = "DecodeISO8601Interval"
    or
    // helper utility for date conversions in qtbase
    this.getName() = "adjacentDay"
    or
    // Windows API function that does timezone conversions
    this.getName().matches("%SystemTimeToTzSpecificLocalTime%")
    or
    // Windows APIs that do time conversions
    this.getName().matches("%localtime%\\_s%")
    or
    // Windows APIs that do time conversions
    this.getName().matches("%SpecificLocalTimeToSystemTime%")
    or
    // postgres function for diffing timestamps, date for leap year
    // is not applicable.
    this.getName().toLowerCase().matches("%timestamp%age%")
    or
    // Reading byte streams often involves operations of some base, but that's
    // not a real source of leap year issues.
    this.getName().toLowerCase().matches("%read%bytes%")
    or
    // A postgres function for local time conversions
    // conversion operations (from one time structure to another) are generally ignorable
    this.getName() = "localsub"
    or
    // Indication of a calendar not applicable to
    // gregorian leap year, e.g., Hijri, Persian, Hebrew
    this.getName().toLowerCase().matches("%hijri%")
    or
    this.getFile().getBaseName().toLowerCase().matches("%hijri%")
    or
    this.getName().toLowerCase().matches("%persian%")
    or
    this.getFile().getBaseName().toLowerCase().matches("%persian%")
    or
    this.getName().toLowerCase().matches("%hebrew%")
    or
    this.getFile().getBaseName().toLowerCase().matches("%hebrew%")
    or
    // misc. from string/char converters heuristic
    this.getName()
        .toLowerCase()
        .matches(["%char%to%", "%string%to%", "%from%char%", "%from%string%"])
    or
    // boost's gregorian.cpp has year manipulations that are checked in complex ways.
    // ignore the entire file as a source or sink.
    this.getFile().getAbsolutePath().toLowerCase().matches("%boost%gregorian.cpp%")
  }
}

/**
 * The set of expressions which are ignorable; either because they seem to not be part of a year mutation,
 * or because they seem to be a conversion pattern of mapping date scalars.
 */
abstract class IgnorableOperation extends Expr { }

class IgnorableExprRem extends IgnorableOperation instanceof RemExpr { }

/**
 * An operation with 10, 100, 1000, 10000 as an operand is often a sign of conversion
 * or atoi.
 */
class IgnorableExpr10MultipleComponent extends IgnorableOperation {
  IgnorableExpr10MultipleComponent() {
    this.(Operation).getAnOperand().getValue().toInt() in [10, 100, 1000, 10000]
    or
    exists(AssignOperation a | a.getRValue() = this |
      a.getRValue().getValue().toInt() in [10, 100, 1000, 10000]
    )
  }
}

/**
 * An operation involving a sub expression with char literal `48`, ignore as a likely string conversion. For example: `X - '0'`
 */
class IgnorableExpr48Mapping extends IgnorableOperation {
  IgnorableExpr48Mapping() {
    this.(SubExpr).getRightOperand().getValue().toInt() = 48
    or
    exists(AssignSubExpr e | e.getRValue() = this | e.getRValue().getValue().toInt() = 48)
  }
}

/**
 * A binary or arithmetic operation whereby one of the components is textual or a string.
 */
class IgnorableCharLiteralArithmetic extends IgnorableOperation {
  IgnorableCharLiteralArithmetic() {
    this.(BinaryArithmeticOperation).getAnOperand() instanceof TextLiteral
    or
    this instanceof TextLiteral and
    any(AssignArithmeticOperation arith).getRValue() = this
  }
}

/**
 * Constants often used in date conversions (from one date data type to another)
 * Numerous examples exist, like 1900 or 2000 that convert years from one
 * representation to another.
 * Also '0' is sometimes observed as an atoi style conversion.
 */
bindingset[c]
predicate isLikelyConversionConstant(int c) {
  exists(int i | i = c.abs() |
    i =
      [
        146097, // days in 400-year Gregorian cycle
        36524, // days in 100-year Gregorian subcycle
        1461, // days in 4-year cycle (incl. 1 leap)
        32044, // Fliegel-van Flandern JDN epoch shift
        1721425, // JDN of 0001-01-01 (Gregorian)
        1721119, // alt epoch offset
        2400000, // MJD -> JDN conversion
        2400001, // alt MJD -> JDN conversion
        2141, // fixed-point month/day extraction
        65536, // observed in some conversions
        7834, // observed in some conversions
        256, // observed in some conversions
        292275056, // qdatetime.h Qt Core year range first year constant
        292278994, // qdatetime.h Qt Core year range last year constant
        1601, // Windows FILETIME epoch start year
        1970, // Unix epoch start year
        70, // Unix epoch start year short form
        1899, // Observed in uses with 1900 to address off by one scenarios
        1900, // Used when converting a 2 digit year
        2000, // Used when converting a 2 digit year
        1400, // Hijri base year, used when converting a 2 digit year
        1980, // FAT filesystem epoch start year
        227013, // constant observed for Hirji year conversion, and Hirji years are not applicable for gregorian leap year
        10631, // constant observed for Hirji year conversion, and Hirji years are not applicable for gregorian leap year,
        80, // 1980/01/01 is the start of the epoch on DOS
        0
      ]
  )
}

/**
 * An `isLikelyConversionConstant` constant indicates conversion that is ignorable, e.g.,
 * julian to gregorian conversion or conversions from linux time structs
 * that start at 1900, etc.
 */
class IgnorableConstantArithmetic extends IgnorableOperation {
  IgnorableConstantArithmetic() {
    exists(int i | isLikelyConversionConstant(i) |
      this.(Operation).getAnOperand().getValue().toInt() = i
      or
      exists(AssignArithmeticOperation a | this = a.getRValue() |
        a.getRValue().getValue().toInt() = i
      )
    )
  }
}

// If a unary minus assume it is some sort of conversion
class IgnorableUnaryMinus extends IgnorableOperation {
  IgnorableUnaryMinus() {
    this instanceof UnaryMinusExpr
    or
    this.(Operation).getAnOperand() instanceof UnaryMinusExpr
  }
}

/**
 * An argument to a function is ignorable if the function that is called is an ignored function
 */
class OperationAsArgToIgnorableFunction extends IgnorableOperation {
  OperationAsArgToIgnorableFunction() {
    exists(Call c |
      c.getAnArgument().getAChild*() = this and
      c.getTarget() instanceof IgnorableFunction
    )
  }
}

/**
 * A binary operation on two literals means the result is constant/known
 * and the operation is basically ignorable (it's not a real operation but
 * probably one visual simplicity what it means).
 */
class ConstantBinaryArithmeticOperation extends IgnorableOperation, BinaryArithmeticOperation {
  ConstantBinaryArithmeticOperation() {
    this.getLeftOperand() instanceof Literal and
    this.getRightOperand() instanceof Literal
  }
}

class IgnorableBinaryBitwiseOperation extends IgnorableOperation instanceof BinaryBitwiseOperation {
}

class IgnorableUnaryBitwiseOperation extends IgnorableOperation instanceof UnaryBitwiseOperation { }

class IgnorableAssignmentBitwiseOperation extends IgnorableOperation instanceof AssignBitwiseOperation
{ }

/**
 * An arithmetic operation where one of the operands is a pointer or char type, ignore it
 */
class IgnorablePointerOrCharArithmetic extends IgnorableOperation {
  IgnorablePointerOrCharArithmetic() {
    this instanceof BinaryArithmeticOperation and
    exists(Expr op | op = this.(BinaryArithmeticOperation).getAnOperand() |
      op.getUnspecifiedType() instanceof PointerType
      or
      op.getUnspecifiedType() instanceof CharType
      or
      // Operations on calls to functions that accept char or char*
      op.(Call).getAnArgument().getUnspecifiedType().stripType() instanceof CharType
      or
      // Operations on calls to functions named like "strlen", "wcslen", etc
      // NOTE: workaround for cases where the wchar_t type is not a char, but an unsigned short
      // unclear if there is a best way to filter cases like these out based on type info.
      op.(Call).getTarget().getName().matches("%len%")
    )
    or
    exists(AssignArithmeticOperation a | a.getRValue() = this |
      exists(Expr op | op = a.getAnOperand() |
        op.getUnspecifiedType() instanceof PointerType
        or
        op.getUnspecifiedType() instanceof CharType
        or
        // Operations on calls to functions that accept char or char*
        op.(Call).getAnArgument().getUnspecifiedType().stripType() instanceof CharType
      )
      or
      // Operations on calls to functions named like "strlen", "wcslen", etc
      // for example `strlen(foo) + bar`
      this.(BinaryArithmeticOperation).getAnOperand().(Call).getTarget().getName().matches("%len%")
    )
  }
}

/**
 * Holds for an expression that is an add or similar operation that could flow to a Year field.
 */
predicate isOperationSourceCandidate(Expr e) {
  not e instanceof IgnorableOperation and
  exists(Function f |
    f = e.getEnclosingFunction() and
    not f instanceof IgnorableFunction
  ) and
  (
    e instanceof SubExpr
    or
    e instanceof AddExpr
    or
    e instanceof CrementOperation
    or
    e instanceof AssignSubExpr
    or
    e instanceof AssignAddExpr
  )
}

/**
 * A data flow that tracks an ignorable operation (such as a bitwise operation) to an operation source, so we may disqualify it.
 */
module IgnorableOperationToOperationSourceCandidateConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof IgnorableOperation }

  predicate isSink(DataFlow::Node n) { isOperationSourceCandidate(n.asExpr()) }

  // looking for sources and sinks in the same function
  DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

module IgnorableOperationToOperationSourceCandidateFlow =
  TaintTracking::Global<IgnorableOperationToOperationSourceCandidateConfig>;

/**
 * The set of all expressions which is a candidate expression and also does not flow from to to some ignorable expression (eg. bitwise op)
 * ```
 * a = something <<< 2;
 * myDate.year = a + 1;        // invalid
 * ...
 * a = someDate.year + 1;
 * myDate.year = a;            // valid
 * ```
 */
class OperationSource extends Expr {
  OperationSource() {
    isOperationSourceCandidate(this) and
    // If the candidate came from an ignorable operation, ignore the candidate
    // NOTE: we cannot easily flow the candidate to an ignorable operation as that can
    // be tricky in practice, e.g., a mod operation on a year would be part of a leap year check
    // but a mod operation ending in a year is more indicative of something to ignore (a conversion)
    not exists(IgnorableOperationToOperationSourceCandidateFlow::PathNode sink |
      sink.getNode().asExpr() = this and
      sink.isSink()
    )
  }
}

class YearFieldAssignmentNode extends DataFlow::Node {
  YearFieldAccess access;

  YearFieldAssignmentNode() {
    exists(Function f |
      f = this.getEnclosingCallable().getUnderlyingCallable() and not f instanceof IgnorableFunction
    ) and
    (
      this.asDefinition().(Assignment).getLValue() = access
      or
      this.asDefinition().(CrementOperation).getOperand() = access
      or
      exists(Call c | c.getAnArgument() = access and this.asDefiningArgument() = access)
      or
      exists(Call c, AddressOfExpr aoe |
        c.getAnArgument() = aoe and
        aoe.getOperand() = access and
        this.asDefiningArgument() = aoe
      )
    )
  }

  YearFieldAccess getYearFieldAccess() { result = access }
}

/**
 * A DataFlow configuration for identifying flows from an identified source
 * to the Year field of a date object.
 */
module OperationToYearAssignmentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof OperationSource }

  predicate isSink(DataFlow::Node n) {
    n instanceof YearFieldAssignmentNode and
    not isYearModifiedWithCheck(n) and
    not isControlledByMonthEqualityCheckNonFebruary(n.asExpr())
  }

  predicate isBarrier(DataFlow::Node n) {
    exists(ArrayExpr arr | arr.getArrayOffset() = n.asExpr())
    or
    n.getType().getUnspecifiedType() instanceof PointerType
    or
    n.getType().getUnspecifiedType() instanceof CharType
    or
    // If a type resembles "string" ignore flow (likely string conversion, currently ignored)
    n.getType().getUnspecifiedType().stripType().getName().toLowerCase().matches("%string%")
    or
    n.asExpr() instanceof IgnorableOperation
    or
    // Flowing into variables that indicate likely non-gregorian years are barriers
    // e.g., names similar to hijri, persian, lunar, chinese, hebrew, etc.
    exists(Variable v |
      v.getName()
          .toLowerCase()
          .matches(["%hijri%", "%persian%", "%lunar%", "%chinese%", "%hebrew%"]) and
      v.getAnAccess() = [n.asIndirectExpr(), n.asExpr()]
    )
    or
    isLeapYearCheckSink(n)
    or
    // this is a bit of a hack to address cases where a year is normalized and checked, but the
    // normalized year is never itself assigned to the final year struct
    //    isLeapYear(getCivilYear(year))
    //    struct.year = year
    // This is assuming a user would have done this all on one line though.
    // setting a variable for the conversion and passing that separately would be more difficult to track
    // considering this approach good enough for current observed false positives
    exists(Expr arg |
      isLeapYearCheckCall(_, arg) and arg.getAChild*() = [n.asExpr(), n.asIndirectExpr()]
    )
    or
    // If as the flow progresses, the value holding a dangerous operation result
    // is apparently being passed by address to some function, it is more than likely
    // intended to be modified, and therefore, the definition is killed.
    exists(Call c | c.getAnArgument().(AddressOfExpr).getAnOperand() = n.asIndirectExpr())
  }

  /** Block flow out of an operation source to get the "closest" operation to the sink */
  predicate isBarrierIn(DataFlow::Node n) { isSource(n) }

  predicate isBarrierOut(DataFlow::Node n) { isSink(n) }
}

module OperationToYearAssignmentFlow = TaintTracking::Global<OperationToYearAssignmentConfig>;

predicate isLeapYearCheckSink(DataFlow::Node sink) {
  exists(LeapYearGuardCondition lgc |
    lgc.checkedYearAccess() = [sink.asExpr(), sink.asIndirectExpr()]
  )
  or
  isLeapYearCheckCall(_, [sink.asExpr(), sink.asIndirectExpr()])
}

predicate yearAssignmentToCheckCommonSteps(DataFlow::Node node1, DataFlow::Node node2) {
  // flow from a YearFieldAccess to the qualifier
  node2.asExpr() = node1.asExpr().(YearFieldAccess).getQualifier*()
  or
  // getting the 'access' can be tricky at definitions (assignments especially)
  // as dataflow uses asDefinition not asExpr.
  // the YearFieldAssignmentNode holds the access in these cases
  node1.(YearFieldAssignmentNode).getYearFieldAccess().getQualifier() = node2.asExpr()
  or
  // flow from a year access qualifier to a year field
  exists(YearFieldAccess yfa | node2.asExpr() = yfa and node1.asExpr() = yfa.getQualifier())
  or
  node1.(YearFieldAssignmentNode).getYearFieldAccess().getQualifier() = node2.asExpr()
  or
  // Pass through any intermediate struct
  exists(Assignment a |
    a.getRValue() = node1.asExpr() and
    node2.asExpr() = a.getLValue().(YearFieldAccess).getQualifier*()
  )
  or
  // in cases of t.year = x and the value of x is checked, but the year t.year isn't directly checked
  // flow from a year assignment node to an RHS if it is an assignment
  // e.g.,
  //    t.year = x;
  //    isLeapYear(x);
  //    --> at this point there is no flow of t.year to a check, but only its raw value
  // To detect the flow of 'x' to the isLeapYear check,
  // flow from t.year to 'x' (at assignment, t.year = x, flow to the RHS to track use-use flow of x)
  exists(YearFieldAssignmentNode yfan |
    node1 = yfan and
    node2.asExpr() = yfan.asDefinition().(Assignment).getRValue()
  )
}

/**
 * A flow configuration from a Year field access to some Leap year check or guard
 */
module YearAssignmentToLeapYearCheckConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof YearFieldAssignmentNode }

  predicate isSink(DataFlow::Node sink) { isLeapYearCheckSink(sink) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    yearAssignmentToCheckCommonSteps(node1, node2)
  }

  /**
   * Enforcing the check must occur in the same call context as the source,
   * i.e., do not return from the source function and check in a caller.
   */
  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

module YearAssignmentToLeapYearCheckFlow =
  TaintTracking::Global<YearAssignmentToLeapYearCheckConfig>;

/** Does there exist a flow from the given YearFieldAccess to a Leap Year check or guard? */
predicate isYearModifiedWithCheck(YearFieldAssignmentNode n) {
  exists(YearAssignmentToLeapYearCheckFlow::PathNode src |
    src.isSource() and
    src.getNode() = n
  )
  or
  // If the time flows to a time conversion whose value/result is checked,
  // assume the leap year is being handled.
  exists(YearAssignmentToCheckedTimeConversionFlow::PathNode timeQualSrc |
    timeQualSrc.isSource() and
    timeQualSrc.getNode() = n
  )
}

/**
 * An expression which checks the value of a Month field `a->month == 1`.
 */
class MonthEqualityCheck extends EqualityOperation {
  MonthEqualityCheck() { this.getAnOperand() instanceof MonthFieldAccess }

  Expr getExprCompared() {
    exists(Expr e |
      e = this.getAnOperand() and
      not e instanceof MonthFieldAccess and
      result = e
    )
  }
}

final class FinalMonthEqualityCheck = MonthEqualityCheck;

class MonthEqualityCheckGuard extends GuardCondition, FinalMonthEqualityCheck { }

/**
 * Verifies if the expression is guarded by a check on the Month property of a date struct, that is NOT February.
 */
bindingset[e]
pragma[inline_late]
predicate isControlledByMonthEqualityCheckNonFebruary(Expr e) {
  exists(MonthEqualityCheckGuard monthGuard, Expr compared |
    monthGuard.controls(e.getBasicBlock(), true) and
    compared = monthGuard.getExprCompared() and
    not compared.getValue().toInt() = 2
  )
}

/**
 * Flow from a year field access to a time conversion function
 * that auto converts feb29 in non-leap year, or through a conversion function that doesn't
 * auto convert to a sanity check guard of the result for error conditions.
 */
module YearAssignmentToCheckedTimeConversionConfig implements DataFlow::StateConfigSig {
  // Flow state tracks if flow goes through a known time conversion function
  // see `TimeConversionFunction`.
  // A valid check with a time conversion function is either the case:
  // 1) the year flows into a time conversion function, and the time conversion function's result is checked or
  // 2) the year flows into a time conversion function that auto corrects for leap year, so no check is necessary.
  class FlowState = boolean;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof YearFieldAssignmentNode and
    state = false
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    // Case 1: Flow through a time conversion function that requires a check,
    // and we have arrived at a guard, implying the result was checked for possible error, including leap year error.
    // state = true indicates the flow went through a time conversion function
    state = true and
    (
      exists(IfStmt ifs | ifs.getCondition().getAChild*() = [sink.asExpr(), sink.asIndirectExpr()])
      or
      exists(ConditionalExpr ce |
        ce.getCondition().getAChild*() = [sink.asExpr(), sink.asIndirectExpr()]
      )
      or
      exists(Loop l | l.getCondition().getAChild*() = [sink.asExpr(), sink.asIndirectExpr()])
    )
    or
    // Case 2: Flow through a time conversion function that auto corrects for leap year, so no check is necessary.
    // state true or false, as flowing through a time conversion function is not necessary in this instance.
    state in [true, false] and
    exists(Call c, TimeConversionFunction f |
      f.isAutoLeapYearCorrecting() and
      c.getTarget() = f and
      c.getAnArgument().getAChild*() = [sink.asExpr(), sink.asIndirectExpr()]
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    state1 in [true, false] and
    state2 = true and
    exists(Call c |
      c.getTarget() instanceof TimeConversionFunction and
      c.getAnArgument().getAChild*() = [node1.asExpr(), node1.asIndirectExpr()] and
      node2.asExpr() = c
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    yearAssignmentToCheckCommonSteps(node1, node2)
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

module YearAssignmentToCheckedTimeConversionFlow =
  DataFlow::GlobalWithState<YearAssignmentToCheckedTimeConversionConfig>;

/**
 * Finds flow from a parameter of a function to a leap year check.
 * This is necessary to handle for scenarios like this:
 *
 *    year = DANGEROUS_OP // source
 *    isLeap = isLeapYear(year);
 *    // logic based on isLeap
 *    struct.year = year; // sink
 *
 * In this case, we may flow a dangerous op to a year assignment, failing
 * to barrier the flow through a leap year check, as the leap year check
 * is nested, and dataflow does not progress down into the check and out.
 * Instead, the point of this flow is to detect isLeapYear's argument
 * is checked for leap year, making the isLeapYear call a barrier for
 * the dangerous flow if we flow through the parameter identified to
 * be checked.
 */
module ParameterToLeapYearCheckConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { exists(source.asParameter()) }

  predicate isSink(DataFlow::Node sink) {
    exists(LeapYearGuardCondition lgc |
      lgc.checkedYearAccess() = [sink.asExpr(), sink.asIndirectExpr()]
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // flow from a YearFieldAccess to the qualifier
    node2.asExpr() = node1.asExpr().(YearFieldAccess).getQualifier*()
    or
    // flow from a year access qualifier to a year field
    exists(YearFieldAccess yfa | node2.asExpr() = yfa and node1.asExpr() = yfa.getQualifier())
  }

  /**
   * Enforcing the check must occur in the same call context as the source,
   * i.e., do not return from the source function and check in a caller.
   */
  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

// NOTE: I do not believe taint flow is necessary here as we should
// be flowing directyly from some parameter to a leap year check.
module ParameterToLeapYearCheckFlow = DataFlow::Global<ParameterToLeapYearCheckConfig>;

predicate isLeapYearCheckCall(Call c, Expr arg) {
  exists(ParameterToLeapYearCheckFlow::PathNode src, Function f, int i |
    src.isSource() and
    f.getParameter(i) = src.getNode().asParameter() and
    c.getTarget() = f and
    c.getArgument(i) = arg
  )
}

class LeapYearGuardCondition extends GuardCondition {
  Expr yearSinkDiv4;
  Expr yearSinkDiv100;
  Expr yearSinkDiv400;

  LeapYearGuardCondition() {
    exists(
      LogicalAndExpr andExpr, LogicalOrExpr orExpr, GuardCondition div4Check,
      GuardCondition div100Check, GuardCondition div400Check, GuardValue gv
    |
      // canonical case:
      // form: `(year % 4 == 0) && (year % 100 != 0 || year % 400 == 0)`
      //    `!((year % 4 == 0) && (year % 100 != 0 || year % 400 == 0))`
      //    `!(year % 4) && (year % 100 || !(year % 400))`
      // Also accepting `((year & 3) == 0) && (year % 100 != 0 || year % 400 == 0)`
      // and `(year % 4 == 0) && (year % 100 > 0 || year % 400 == 0)`
      this = andExpr and
      andExpr.hasOperands(div4Check, orExpr) and
      orExpr.hasOperands(div100Check, div400Check) and
      (
        // year % 4 == 0
        exists(RemExpr e |
          div4Check.comparesEq(e, 0, true, gv) and
          e.getRightOperand().getValue().toInt() = 4 and
          yearSinkDiv4 = e.getLeftOperand()
        )
        or
        // year & 3 == 0
        exists(BitwiseAndExpr e |
          div4Check.comparesEq(e, 0, true, gv) and
          e.getRightOperand().getValue().toInt() = 3 and
          yearSinkDiv4 = e.getLeftOperand()
        )
      ) and
      exists(RemExpr e |
        // year % 100 != 0 or year % 100 > 0
        (
          div100Check.comparesEq(e, 0, false, gv) or
          div100Check.comparesLt(e, 1, false, gv)
        ) and
        e.getRightOperand().getValue().toInt() = 100 and
        yearSinkDiv100 = e.getLeftOperand()
      ) and
      // year % 400 == 0
      exists(RemExpr e |
        div400Check.comparesEq(e, 0, true, gv) and
        e.getRightOperand().getValue().toInt() = 400 and
        yearSinkDiv400 = e.getLeftOperand()
      )
      or
      // Inverted logic case:
      //  `year % 4 != 0 || (year % 100 == 0 && year % 400 != 0)`
      // or `year & 3 != 0 || (year % 100 == 0 && year % 400 != 0)`
      // also accepting `year % 4 > 0 || (year % 100 == 0 && year % 400 > 0)`
      this = orExpr and
      orExpr.hasOperands(div4Check, andExpr) and
      andExpr.hasOperands(div100Check, div400Check) and
      (
        // year % 4 != 0 or year % 4 > 0
        exists(RemExpr e |
          (
            div4Check.comparesEq(e, 0, false, gv)
            or
            div4Check.comparesLt(e, 1, false, gv)
          ) and
          e.getRightOperand().getValue().toInt() = 4 and
          yearSinkDiv4 = e.getLeftOperand()
        )
        or
        // year & 3 != 0
        exists(BitwiseAndExpr e |
          div4Check.comparesEq(e, 0, false, gv) and
          e.getRightOperand().getValue().toInt() = 3 and
          yearSinkDiv4 = e.getLeftOperand()
        )
      ) and
      // year % 100 == 0
      exists(RemExpr e |
        div100Check.comparesEq(e, 0, true, gv) and
        e.getRightOperand().getValue().toInt() = 100 and
        yearSinkDiv100 = e.getLeftOperand()
      ) and
      // year % 400 != 0 or year % 400 > 0
      exists(RemExpr e |
        (
          div400Check.comparesEq(e, 0, false, gv)
          or
          div400Check.comparesLt(e, 1, false, gv)
        ) and
        e.getRightOperand().getValue().toInt() = 400 and
        yearSinkDiv400 = e.getLeftOperand()
      )
    )
  }

  Expr getYearSinkDiv4() { result = yearSinkDiv4 }

  Expr getYearSinkDiv100() { result = yearSinkDiv100 }

  Expr getYearSinkDiv400() { result = yearSinkDiv400 }

  /**
   * Gets the variable access that is used in all 3 components of the leap year check
   * e.g., see getYearSinkDiv4/100/400..
   * If a field access is used, the qualifier and the field access are both returned
   * in checked condition.
   * NOTE: if the year is not checked using the same access in all 3 components, no result is returned.
   * The typical case observed is a consistent variable access is used. If not, this may indicate a bug.
   * We could check more accurately with a dataflow analysis, but this is likely sufficient for now.
   */
  VariableAccess checkedYearAccess() {
    exists(Variable var |
      (
        this.getYearSinkDiv4().getAChild*() = var.getAnAccess() and
        this.getYearSinkDiv100().getAChild*() = var.getAnAccess() and
        this.getYearSinkDiv400().getAChild*() = var.getAnAccess() and
        result = var.getAnAccess() and
        (
          result = this.getYearSinkDiv4().getAChild*() or
          result = this.getYearSinkDiv100().getAChild*() or
          result = this.getYearSinkDiv400().getAChild*()
        )
      )
    )
  }
}

/**
 * A difficult case to detect is if a year modification is tied to a month or day modification
 * and the month or day is safe for leap year.
 *    e.g.,
 *          year++;
 *          month = 1;
 *          // alternative: day = 15;
 *        ... values eventually used in the same time struct
 * If this is even more challenging if the struct the values end up in are not
 * local (set inter-procedurally).
 * This configuration looks for constants 1-31 flowing to a month or day assignment.
 * It is assumed a user of this flow will check if the month/day source and month/day sink
 * are in the same basic blocks as a year modification source and a year modification sink.
 * It is also assumed a user will check if the constant source is a value that is ignorable
 * e.g., if it is 2 and the sink is a month assignment, then it isn't ignorable or
 * if the value is < 27 and is a day assignment, it is likely ignorable
 *
 * Obviously this does not handle all conditions (e.g., the month set in another block).
 * It is meant to capture the most common cases of false positives.
 */
module CandidateConstantToDayOrMonthAssignmentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().getValue().toInt() in [1 .. 31] and
    (
      exists(Assignment a | a.getRValue() = source.asExpr())
      or
      exists(Call c | c.getAnArgument() = source.asExpr())
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Assignment a |
      (a.getLValue() instanceof MonthFieldAccess or a.getLValue() instanceof DayFieldAccess) and
      a.getRValue() = sink.asExpr()
    )
  }
}

// NOTE: only data flow here (no taint tracking) as we want the exact
// constant flowing to the month assignment
module CandidateConstantToDayOrMonthAssignmentFlow =
  DataFlow::Global<CandidateConstantToDayOrMonthAssignmentConfig>;

/**
 * Holds if value the assignment `a` resolves to (`dayOrMonthValSrcExpr`) doesn't represent February,
 * and/or if it represents a day, is a 'safe' day (meaning the 27th or prior).
 */
bindingset[dayOrMonthValSrcExpr]
predicate isSafeValueForAssignmentOfMonthOrDayValue(Assignment a, Expr dayOrMonthValSrcExpr) {
  a.getLValue() instanceof MonthFieldAccess and
  dayOrMonthValSrcExpr.getValue().toInt() != 2
  or
  a.getLValue() instanceof DayFieldAccess and
  dayOrMonthValSrcExpr.getValue().toInt() <= 27
}

import OperationToYearAssignmentFlow::PathGraph

from OperationToYearAssignmentFlow::PathNode src, OperationToYearAssignmentFlow::PathNode sink
where
  OperationToYearAssignmentFlow::flowPath(src, sink) and
  // Check if a month is set in the same block as the year operation source
  // and the month value would indicate its set to any other month than february.
  // Finds if the source year node is in the same block as a source month block
  // and if the same for the sinks.
  not exists(DataFlow::Node dayOrMonthValSrc, DataFlow::Node dayOrMonthValSink, Assignment a |
    CandidateConstantToDayOrMonthAssignmentFlow::flow(dayOrMonthValSrc, dayOrMonthValSink) and
    a.getRValue() = dayOrMonthValSink.asExpr() and
    dayOrMonthValSink.getBasicBlock() = sink.getNode().getBasicBlock() and
    exists(IRBlock dayOrMonthValBB |
      dayOrMonthValBB = dayOrMonthValSrc.getBasicBlock() and
      // The source of the day is set in the same block as the source for the year
      // or the source for the day is set in the same block as the sink for the year
      dayOrMonthValBB in [
          src.getNode().getBasicBlock(),
          sink.getNode().getBasicBlock()
        ]
    ) and
    isSafeValueForAssignmentOfMonthOrDayValue(a, dayOrMonthValSrc.asExpr())
  )
select sink, src, sink,
  "Year field has been modified, but no appropriate check for LeapYear was found."
