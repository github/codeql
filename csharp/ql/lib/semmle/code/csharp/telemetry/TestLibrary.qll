/** Provides classes and predicates related to handling test libraries. */
overlay[local?]
module;

private import csharp

pragma[nomagic]
private predicate isTestNamespace(Namespace ns) {
  ns.getFullName()
      .matches([
          "NUnit.Framework%", "Xunit%", "Microsoft.VisualStudio.TestTools.UnitTesting%", "Moq%"
        ])
}

/**
 * A test library.
 */
class TestLibrary extends RefType {
  TestLibrary() { isTestNamespace(this.getNamespace()) }
}
