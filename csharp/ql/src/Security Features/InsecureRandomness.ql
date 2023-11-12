/**
 * @name Insecure randomness
 * @description Using a cryptographically weak pseudo-random number generator to generate a
 *              security sensitive value may allow an attacker to predict what sensitive value will
 *              be generated.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id cs/insecure-randomness
 * @tags security
 *       external/cwe/cwe-338
 */

import csharp
import semmle.code.csharp.frameworks.Test
import Random::InsecureRandomness::PathGraph

module Random {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.security.SensitiveActions

  /**
   * A data flow sink for insecure randomness in security sensitive context.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A data flow source for insecure randomness in security sensitive context.
   */
  abstract class Source extends DataFlow::ExprNode { }

  /**
   * A sanitizer for insecure randomness in security sensitive context.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for insecure randomness in security sensitive context.
   */
  module InsecureRandomnessConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      // succ = array_or_indexer[pred] - use of random numbers in an index
      succ.asExpr().(ElementAccess).getAnIndex() = pred.asExpr()
    }
  }

  /**
   * A taint-tracking module for insecure randomness in security sensitive context.
   */
  module InsecureRandomness = TaintTracking::Global<InsecureRandomnessConfig>;

  /** A source of cryptographically insecure random numbers. */
  class RandomSource extends Source {
    RandomSource() {
      this.getExpr() =
        any(MethodCall mc |
          mc.getQualifier().getType().(RefType).hasFullyQualifiedName("System", "Random")
          or
          // by using `% 87` on a `byte`, `System.Web.Security.Membership.GeneratePassword` has a bias
          mc.getQualifier()
              .getType()
              .(RefType)
              .hasFullyQualifiedName("System.Web.Security", "Membership") and
          mc.getTarget().hasName("GeneratePassword")
        )
    }
  }

  /** A value assigned to a property, variable or parameter which holds security sensitive data. */
  class SensitiveSink extends Sink {
    SensitiveSink() {
      exists(Expr e |
        // Simple assignment
        e = this.getExpr()
      |
        e = any(SensitiveVariable v).getAnAssignedValue()
        or
        e = any(SensitiveProperty v).getAnAssignedValue()
        or
        e = any(SensitiveLibraryParameter v).getAnAssignedArgument()
        or
        // Assignment operation, e.g. += or similar
        exists(AssignOperation ao |
          ao.getRValue() = e and
          // "expanded" assignments will be covered by simple assignment
          not ao.hasExpandedAssignment()
        |
          ao.getLValue() = any(SensitiveVariable v).getAnAccess() or
          ao.getLValue() = any(SensitiveProperty v).getAnAccess() or
          ao.getLValue() = any(SensitiveLibraryParameter v).getAnAccess()
        )
      )
    }
  }

  /**
   * Stop tracking beyond first assignment to sensitive element, so as to remove duplication in the
   * reported results.
   */
  class AlreadyTrackedSanitizer extends Sanitizer {
    AlreadyTrackedSanitizer() {
      exists(Expr e | e = this.getExpr() |
        e = any(SensitiveVariable v).getAnAccess() or
        e = any(SensitiveProperty v).getAnAccess() or
        e = any(SensitiveLibraryParameter v).getAnAccess()
      )
    }
  }
}

from Random::InsecureRandomness::PathNode source, Random::InsecureRandomness::PathNode sink
where Random::InsecureRandomness::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This uses a cryptographically insecure random number generated at $@ in a security context.",
  source.getNode(), source.getNode().toString()
