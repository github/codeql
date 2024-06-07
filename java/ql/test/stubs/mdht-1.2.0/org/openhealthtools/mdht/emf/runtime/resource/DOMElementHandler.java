// Generated automatically from org.openhealthtools.mdht.emf.runtime.resource.DOMElementHandler for testing purposes

package org.openhealthtools.mdht.emf.runtime.resource;

import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.xmi.XMLHelper;
import org.w3c.dom.Element;

public interface DOMElementHandler
{
    boolean handleElement(Element p0, Element p1, XMLHelper p2);
    static public interface Registry
    {
        DOMElementHandler.Registry registerHandler(EPackage p0, DOMElementHandler p1);
        Iterable<DOMElementHandler> getHandlers(EPackage p0);
        static DOMElementHandler.Registry INSTANCE = null;
    }
}
