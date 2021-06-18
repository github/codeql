/**
 * @name Thread-unsafe use of a static ICryptoTransform field
 * @description The class has a field that directly or indirectly make use of a static System.Security.Cryptography.ICryptoTransform object.
 *              Using this an instance of this class in concurrent threads is dangerous as it may not only result in an error,
 *              but under some circumstances may also result in incorrect results.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.0
 * @precision medium
 * @id cs/thread-unsafe-icryptotransform-field-in-class
 * @tags concurrency
 *       security
 *       external/cwe/cwe-362
 */

import csharp
import semmle.code.csharp.frameworks.system.collections.Generic

class UnsafeField extends Field {
  UnsafeField() {
    this.isStatic() and
    not this.getAnAttribute().getType().getQualifiedName() = "System.ThreadStaticAttribute" and
    this.getType() instanceof UsesICryptoTransform
  }
}

ValueOrRefType getAnEnumeratedType(ValueOrRefType type) {
  exists(ConstructedInterface interface |
    interface = type.getABaseInterface*() and
    interface.getUnboundGeneric() instanceof SystemCollectionsGenericIEnumerableTInterface
  |
    result = interface.getATypeArgument()
  )
}

class UsesICryptoTransform extends ValueOrRefType {
  UsesICryptoTransform() {
    this instanceof ICryptoTransform
    or
    this.getAField().getType() instanceof UsesICryptoTransform
    or
    this.getAProperty().getType() instanceof UsesICryptoTransform
    or
    getAnEnumeratedType(this) instanceof UsesICryptoTransform
  }
}

class ICryptoTransform extends ValueOrRefType {
  ICryptoTransform() {
    this.getABaseType*().hasQualifiedName("System.Security.Cryptography", "ICryptoTransform")
  }
}

from UnsafeField field
select field,
  "Static field '" + field.getName() +
    "' contains a 'System.Security.Cryptography.ICryptoTransform' that could be used in an unsafe way."
