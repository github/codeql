/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression1
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A gzFile Variable as a Flow source
 */
private class GzFileVar extends VariableAccess {
  GzFileVar() { this.getType().hasName("gzFile") }
}

/**
 * The `gzopen` function as a Flow source
 */
private class GzopenFunction extends Function {
  GzopenFunction() { hasGlobalName("gzopen") }
}

/**
 * The `gzdopen` function as a Flow source
 */
private class GzdopenFunction extends Function {
  GzdopenFunction() { hasGlobalName("gzdopen") }
}

/**
 * The `gzfread` function is used in Flow sink
 */
private class GzfreadFunction extends Function {
  GzfreadFunction() { hasGlobalName("gzfread") }
}

/**
 * The `gzread` function is used in Flow sink
 */
private class GzreadFunction extends Function {
  GzreadFunction() { hasGlobalName("gzread") }
}

module ZlibTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // gzopen(const char *path, const char *mode);
    exists(FunctionCall fc | fc.getTarget() instanceof GzopenFunction |
      fc.getArgument(0) = source.asExpr() and
      // arg 0 can be a path string whichwe must do following check
      not fc.getArgument(0).isConstant()
    )
    or
    //gzdopen(int fd, const char *mode);
    // IDK whether it is good to use all file decriptors function returns as source or not
    // because we can do more sanitization from fd function sources
    exists(FunctionCall fc | fc.getTarget() instanceof GzdopenFunction |
      fc.getArgument(0) = source.asExpr()
    )
    or
    source.asExpr() instanceof GzFileVar
  }

  predicate isSink(DataFlow::Node sink) {
    // gzread(gzFile file, voidp buf, unsigned len));
    exists(FunctionCall fc | fc.getTarget() instanceof GzreadFunction |
      fc.getArgument(0) = sink.asExpr() and
      not sanitizer(fc)
      // TODO: and not sanitizer2(fc.getArgument(2))
    )
    or
    // gzfread((voidp buf, z_size_t size, z_size_t nitems, gzFile file));
    exists(FunctionCall fc | fc.getTarget() instanceof GzfreadFunction |
      sink.asExpr() = fc.getArgument(3)
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // gzopen(const char *path, const char *mode);
    // gzdopen(int fd, const char *mode);
    exists(FunctionCall fc |
      fc.getTarget() instanceof GzopenFunction or fc.getTarget() instanceof GzdopenFunction
    |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
    or
    // gzread(gzFile file, voidp buf, unsigned len);
    exists(FunctionCall fc | fc.getTarget() instanceof GzreadFunction |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1)
    )
    or
    // gzfread(voidp buf, z_size_t size, z_size_t nitems, gzFile file);
    exists(FunctionCall fc | fc.getTarget() instanceof GzfreadFunction |
      node1.asExpr() = fc.getArgument(3) and
      node2.asExpr() = fc.getArgument(0)
    )
  }
}

predicate sanitizer(FunctionCall fc) {
  exists(Expr e |
    // a RelationalOperation which isn't compared with a Literal that using for end of read
    TaintTracking::localExprTaint(fc, e.(RelationalOperation).getAChild*()) and
    not e.getAChild*().(Literal).getValue() = ["0", "1", "-1"]
  )
}

// TODO:
// predicate sanitizer2(Expr arg) {
//   exists(Expr e |
//     // a RelationalOperation which isn't compared with a Literal that using for end of read
//     TaintTracking::localExprTaint(arg, e.(RelationalOperation).getAChild*())
//   )
// }
// predicate test(FunctionCall fc, Expr sink) {
//   exists( | fc.getTarget() instanceof GzreadFunction |
//     // a RelationalOperation which isn't compared with a Literal that using for end of read
//     TaintTracking::localExprTaint(fc.getArgument(2).(VariableAccess), sink)
//   ) and
//   sink.getFile().getLocation().toString().matches("%main.cpp%")
// }
module ZlibTaint = TaintTracking::Global<ZlibTaintConfig>;

import ZlibTaint::PathGraph

from ZlibTaint::PathNode source, ZlibTaint::PathNode sink
where ZlibTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompressiondepends on a $@.", source.getNode(),
  "potentially untrusted source"
