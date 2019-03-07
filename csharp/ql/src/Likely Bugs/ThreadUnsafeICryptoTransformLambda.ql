/**
 * @name Potential usage of a n object implementing ICryptoTransform class in a way that would be unsafe for concurrent threads.
 * @description An instance of a class that either implements or has a field of type System.Security.Cryptography.ICryptoTransform is being captured by a lambda, 
 *              and used in what seems to be a thread initialization method.
 *              Using this an instance of this class in concurrent threads is dangerous as it may not only result in an error, 
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

class ICryptoTransform extends Class {
  ICryptoTransform() {
    this.getABaseType*().hasQualifiedName("System.Security.Cryptography", "ICryptoTransform")
  }
}

predicate usesICryptoTransformType( Type t ) {
  exists(  ICryptoTransform ict |
    ict = t
    or usesICryptoTransformType( t.getAChild() )
    or usesICryptoTransformType( t.(Class).getAMember() )
  )
}

predicate hasICryptoTransformMember( Class c) {
  exists( Field f |
    f = c.getAMember()
    and ( 
      exists( ICryptoTransform ict | ict = f.getType() )
      or hasICryptoTransformMember(f.getType())
      or usesICryptoTransformType(f.getType())
    )
  )
}

class UsesICryptoTransform extends Class {
  UsesICryptoTransform() {
    usesICryptoTransformType(this) or hasICryptoTransformMember(this)
  }
}

class NotThreadSafeCryptoUsageIntoStartingCallingConfig extends TaintTracking::Configuration  {
  NotThreadSafeCryptoUsageIntoStartingCallingConfig() { this = "NotThreadSafeCryptoUsageIntoStartingCallingConfig" }
 
  override predicate isSource(DataFlow::Node source) {    
    exists( LambdaExpr l, LocalScopeVariable lsvar, UsesICryptoTransform ict |
      l = source.asExpr() |
      ict = lsvar.getType()
      and lsvar.getACapturingCallable() = l
    )
  }
 
  override predicate isSink(DataFlow::Node sink) {
    exists( DelegateCreation dc, Expr e | 
      e = sink.asExpr() |
      dc.getArgument() = e
      and dc.getType().getName().matches("%Start")
    )
  }
}

from NotThreadSafeCryptoUsageIntoStartingCallingConfig  config, LambdaExpr l, Expr e
where config.hasFlow(DataFlow::exprNode(l), DataFlow::exprNode(e))
select e, "A Lambda expression at " + l.getLocation() + " seems to be used to start a new thread is capturing a local variable that either implements 'System.Security.Cryptography.ICryptoTransform' or has a field of this type."
