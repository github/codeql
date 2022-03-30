import semmle.python.dependencies.Dependencies

/**
 * A library describing an abstract mechanism for representing dependency categories.
 */
/*
 * A DependencyCategory is a unique string key used by Architect to identify different categories
 * of dependencies that might be viewed independently.
 * <p>
 * The string key defining the category must adhere to the isValid(), otherwise it will not be
 * accepted by Architect.
 * </p>
 */

abstract class DependencyKind extends string {
  bindingset[this]
  DependencyKind() { this = this }

  /* Tech inventory interface */
  /**
   * Identify dependencies associated with this category.
   * <p>
   * The source element is the source of the dependency.
   * </p>
   */
  abstract predicate isADependency(AstNode source, Object target);
}
