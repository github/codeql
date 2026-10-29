import cpp

/**
 * A wrapper that provides metrics for a C/C++ namespace.
 */
class MetricNamespace extends Namespace {
  /** Gets the number of incoming dependencies from other namespaces. */
  int getAfferentCoupling() {
    result = count(MetricNamespace that | that.getANamespaceDependency() = this)
  }

  /** Gets the number of outgoing dependencies on other namespaces. */
  int getEfferentCoupling() {
    result = count(MetricNamespace that | this.getANamespaceDependency() = that)
  }

  /**
   * Gets the _instability_ of this namespace. Instability is a measure of how
   * likely a namespace is to be influenced by changes to other namespace. If
   * this metric value is high, it is easily influenced, if it is low, the
   * impact is likely to be minimal. Instability is estimated as the number of
   * outgoing dependencies relative to the total number of dependencies.
   */
  float getInstability() {
    exists(int ecoupling, int sumcoupling |
      ecoupling = this.getEfferentCoupling() and
      sumcoupling = ecoupling + this.getAfferentCoupling() and
      sumcoupling > 0 and
      result = ecoupling / sumcoupling.(float)
    )
  }

  /**
   * Gets the _abstractness_ of this namespace. Abstractness measures the
   * proportion of abstract classes in a namespace relative to the total number
   * of classes in that namespace. A highly abstract namespace (where the
   * metric value is close 1) that is furthermore instable is likely to be
   * useless: the class hierarchy has been over-engineered, and all those
   * abstract classes are not heavily used.
   */
  float getAbstractness() {
    exists(int i, int j |
      i = count(Class c | c.getNamespace() = this) and
      j =
        count(Class c |
          c.getNamespace() = this and
          c.isAbstract()
        ) and
      result = j / i.(float) and
      i > 0
    )
  }

  /**
   * Gets the _distance from main sequence_ of this namespace. This measure
   * intends to capture the tradeoff between abstractness and instability: the
   * ideal situation occurs when the sum of abstractness and instability is
   * one. That is, a namespace is completely abstract and stable
   * (abstractness=1 and instability=0) or it is concrete and instable
   * (abstractness=0 and instability=1). We thus measure the distance from that
   * ideal situation.
   */
  float getDistanceFromMain() {
    exists(float r |
      r = this.getAbstractness() + this.getInstability() - 1 and
      (
        r >= 0 and result = r
        or
        r < 0 and result = -r
      )
    )
  }

  /** Gets a namespace dependency of this element. */
  MetricNamespace getANamespaceDependency() {
    exists(MetricClass c |
      c.getNamespace() = this and
      c.getAClassDependency().getNamespace() = result
    )
    or
    exists(FunctionCall c |
      c.getEnclosingFunction().getNamespace() = this and
      c.getTarget().getNamespace() = result
    )
    or
    exists(FunctionCall c |
      c.getEnclosingVariable().getNamespace() = this and
      c.getTarget().getNamespace() = result
    )
    or
    exists(Access a |
      a.getEnclosingFunction().getNamespace() = this and
      a.getTarget().getNamespace() = result
    )
    or
    exists(Access a |
      a.getEnclosingVariable().getNamespace() = this and
      a.getTarget().getNamespace() = result
    )
    or
    exists(Variable v, UserType t |
      v.getNamespace() = this and
      v.getType().refersTo(t) and
      t.getNamespace() = result
    )
    or
    exists(Function f, UserType t |
      f.getNamespace() = this and
      f.getType().refersTo(t) and
      t.getNamespace() = result
    )
  }
}
