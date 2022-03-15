/** Utilities for handling the zope libraries */

import python
private import semmle.python.pointsto.PointsTo

/** A method that belongs to a sub-class of `zope.interface.Interface` */
class ZopeInterfaceMethodValue extends PythonFunctionValue {
  /** Holds if this method belongs to a class that sub-classes `zope.interface.Interface` */
  ZopeInterfaceMethodValue() {
    exists(Value interface, ClassValue owner |
      interface = Module::named("zope.interface").attr("Interface") and
      owner.declaredAttribute(_) = this and
      // `zope.interface.Interface` will be recognized as a Value by the pointsTo analysis,
      // because it is the result of instantiating a "meta" class. getASuperType only returns
      // ClassValues, so we do this little trick to make things work
      Types::getBase(owner.getASuperType(), _) = interface
    )
  }

  override int minParameters() { result = super.minParameters() + 1 }

  override int maxParameters() {
    if exists(this.getScope().getVararg())
    then result = super.maxParameters()
    else result = super.maxParameters() + 1
  }
}
