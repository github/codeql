// Generated automatically from org.eclipse.emf.ecore.resource.ResourceSet for testing purposes

package org.eclipse.emf.ecore.resource;

import java.util.Map;
import org.eclipse.emf.common.notify.AdapterFactory;
import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.URIConverter;

public interface ResourceSet extends Notifier
{
    EList<AdapterFactory> getAdapterFactories();
    EList<Resource> getResources();
    EObject getEObject(URI p0, boolean p1);
    EPackage.Registry getPackageRegistry();
    Map<Object, Object> getLoadOptions();
    Resource createResource(URI p0);
    Resource createResource(URI p0, String p1);
    Resource getResource(URI p0, boolean p1);
    Resource.Factory.Registry getResourceFactoryRegistry();
    TreeIterator<Notifier> getAllContents();
    URIConverter getURIConverter();
    static int RESOURCE_SET__RESOURCES = 0;
    void setPackageRegistry(EPackage.Registry p0);
    void setResourceFactoryRegistry(Resource.Factory.Registry p0);
    void setURIConverter(URIConverter p0);
}
