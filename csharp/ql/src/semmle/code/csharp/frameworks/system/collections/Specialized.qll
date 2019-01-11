/** Provides definitions related to the namespace `System.Collections.Specialized`. */

import csharp
private import semmle.code.csharp.frameworks.system.Collections

/** The `System.Collections.Specialized` namespace. */
class SystemCollectionsSpecializedNamespace extends Namespace {
  SystemCollectionsSpecializedNamespace() {
    this.getParentNamespace() instanceof SystemCollectionsNamespace and
    this.hasName("Specialized")
  }
}

/** A class in the `System.Collections.Specialized` namespace. */
class SystemCollectionsSpecializedClass extends Class {
  SystemCollectionsSpecializedClass() {
    this.getNamespace() instanceof SystemCollectionsSpecializedNamespace
  }
}

/** The `System.Collections.Specialized.NameValueCollection` class. */
class SystemCollectionsSpecializedNameValueCollectionClass extends SystemCollectionsSpecializedClass {
  SystemCollectionsSpecializedNameValueCollectionClass() { this.hasName("NameValueCollection") }
}
