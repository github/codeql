// Generated automatically from org.openhealthtools.mdht.emf.runtime.resource.FleXMLResourceSet for testing purposes

package org.openhealthtools.mdht.emf.runtime.resource;

import org.eclipse.emf.ecore.resource.ResourceSet;
import org.openhealthtools.mdht.emf.runtime.resource.DOMElementHandler;
import org.openhealthtools.mdht.emf.runtime.resource.FleXMLResource;
import org.openhealthtools.mdht.emf.runtime.resource.XSITypeProvider;

public interface FleXMLResourceSet extends ResourceSet
{
    DOMElementHandler.Registry getDOMElementHandlerRegistry();
    FleXMLResourceSet setDOMElementHandlerRegistry(DOMElementHandler.Registry p0);
    FleXMLResourceSet setDefaultResourceFactory(FleXMLResource.Factory p0);
    FleXMLResourceSet setXSITypeProviderRegistry(XSITypeProvider.Registry p0);
    XSITypeProvider.Registry getXSITypeProviderRegistry();
}
