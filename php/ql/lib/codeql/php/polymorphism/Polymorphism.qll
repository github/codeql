/**
 * @name Polymorphism Analysis
 * @description Complete polymorphism analysis framework for PHP
 * @kind shared
 */

// Phase 1: Foundation - Class and Name Resolution
import codeql.php.polymorphism.ClassResolver
import codeql.php.polymorphism.NameResolution

// Phase 2: Method Resolution - Dispatch and Visibility
import codeql.php.polymorphism.MethodResolver
import codeql.php.polymorphism.MethodLookup
import codeql.php.polymorphism.StaticMethodResolution

// Phase 3: Composition - Traits and Magic Methods
import codeql.php.polymorphism.TraitUsage
import codeql.php.polymorphism.TraitComposition
import codeql.php.polymorphism.MagicMethods

// Phase 4: Type Safety - Overrides and Variance
import codeql.php.polymorphism.OverrideValidation
import codeql.php.polymorphism.PolymorphicTypeChecking
import codeql.php.polymorphism.VarianceChecking

// Phase 5: Advanced Dispatch Patterns
import codeql.php.polymorphism.InterfaceDispatch
import codeql.php.polymorphism.PolymorphicDataFlow
import codeql.php.polymorphism.DuckTyping
import codeql.php.polymorphism.ContextualDispatch

// Phase 6: Integration and Security
import codeql.php.polymorphism.TypeSystemIntegration
import codeql.php.polymorphism.PolymorphismOptimization
import codeql.php.polymorphism.DataFlowIntegration
import codeql.php.polymorphism.VulnerabilityDetection

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * Gets the polymorphism complexity of a class.
 */
int getPolymorphismComplexity(PhpClassDecl c) {
  result = getInheritanceDepth(c) + getDirectTraitCount(c)
}
