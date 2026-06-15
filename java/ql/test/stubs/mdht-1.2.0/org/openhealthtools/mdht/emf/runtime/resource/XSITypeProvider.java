// Generated automatically from org.openhealthtools.mdht.emf.runtime.resource.XSITypeProvider for testing purposes

package org.openhealthtools.mdht.emf.runtime.resource;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EPackage;
import org.w3c.dom.Element;

public interface XSITypeProvider
{
    EClass getXSIType(Element p0);
    static public interface Registry
    {
        XSITypeProvider getXSITypeProvider(EPackage p0);
        XSITypeProvider.Registry registerXSITypeProvider(EPackage p0, XSITypeProvider p1);
        static XSITypeProvider.Registry INSTANCE = null;
    }
}
