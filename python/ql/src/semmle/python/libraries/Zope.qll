/** Utilities for handling the zope libraries */

import python

/** A method that to a sub-class of `zope.interface.Interface` */
class ZopeInterfaceMethod extends PyFunctionObject {

    /** Holds if this method belongs to a class that sub-classes `zope.interface.Interface` */
    ZopeInterfaceMethod() {
        exists(ModuleObject zope, Object interface, ClassObject owner |
            zope.getAttribute("Interface") = interface and
            zope.getName() = "zope.interface" and
            owner.declaredAttribute(_) = this and
            owner.getAnImproperSuperType().getABaseType() = interface
        )
    }

    override int minParameters() {
        result = super.minParameters() + 1
    }

    override int maxParameters() {
        if exists(this.getFunction().getVararg()) then
            result = super.maxParameters()
        else
            result = super.maxParameters() + 1
    }

}
