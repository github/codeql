/**
 * @name Thread-unsafe capturing of an ICryptoTransform object
 * @description An instance of a class that either implements or has a field of type System.Security.Cryptography.ICryptoTransform is being captured by a lambda,
 *              and used in what seems to be a thread initialization method.
 *              Using an instance of this class in concurrent threads is dangerous as it may not only result in an error,
 *              but under some circumstances may also result in incorrect results.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.0
 * @precision medium
 * @id cs/thread-unsafe-icryptotransform-captured-in-lambda
 * @tags concurrency
 *       security
 *       external/cwe/cwe-362
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsinks.ParallelSink
import ICryptoTransform

module NotThreadSafeCryptoUsageIntoParallelInvokeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof LambdaCapturingICryptoTransformSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof ParallelSink }
}

module NotThreadSafeCryptoUsageIntoParallelInvoke =
  TaintTracking::Global<NotThreadSafeCryptoUsageIntoParallelInvokeConfig>;

from Expr e, string m, LambdaExpr l
where
  NotThreadSafeCryptoUsageIntoParallelInvoke::flow(DataFlow::exprNode(l), DataFlow::exprNode(e)) and
  m =
    "A $@ seems to be used to start a new thread is capturing a local variable that either implements 'System.Security.Cryptography.ICryptoTransform' or has a field of this type."
select e, m, l, "lambda expression"
