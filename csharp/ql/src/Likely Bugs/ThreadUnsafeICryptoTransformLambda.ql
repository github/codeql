/**
 * @name Thread-unsafe capturing of an ICryptoTransform object
 * @description An instance of a class that either implements or has a field of type System.Security.Cryptography.ICryptoTransform is being captured by a lambda,
 *              and used in what seems to be a thread initialization method.
 *              Using an instance of this class in concurrent threads is dangerous as it may not only result in an error,
 *              but under some circumstances may also result in incorrect results.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/thread-unsafe-icryptotransform-captured-in-lambda
 * @tags concurrency
 *       security
 *       external/cwe/cwe-362
 */

import csharp
import semmle.code.csharp.dataflow.DataFlow
import ParallelSink
import ICryptoTransform

class NotThreadSafeCryptoUsageIntoParallelInvokeConfig extends TaintTracking::Configuration {
  NotThreadSafeCryptoUsageIntoParallelInvokeConfig() {
    this = "NotThreadSafeCryptoUsageIntoParallelInvokeConfig"
  }

  override predicate isSource(DataFlow::Node source) {
    source instanceof LambdaCapturingICryptoTransformSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ParallelSink }
}

from Expr e, string m, LambdaExpr l, NotThreadSafeCryptoUsageIntoParallelInvokeConfig config
where
  config.hasFlow(DataFlow::exprNode(l), DataFlow::exprNode(e)) and
  m =
    "A $@ seems to be used to start a new thread is capturing a local variable that either implements 'System.Security.Cryptography.ICryptoTransform' or has a field of this type."
select e, m, l, "lambda expression"
