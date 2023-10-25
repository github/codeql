// Generated automatically from org.eclipse.emf.ecore.resource.URIHandler for testing purposes

package org.eclipse.emf.ecore.resource;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import org.eclipse.emf.common.util.URI;

public interface URIHandler
{
    InputStream createInputStream(URI p0, Map<? extends Object, ? extends Object> p1);
    Map<String, ? extends Object> contentDescription(URI p0, Map<? extends Object, ? extends Object> p1);
    Map<String, ? extends Object> getAttributes(URI p0, Map<? extends Object, ? extends Object> p1);
    OutputStream createOutputStream(URI p0, Map<? extends Object, ? extends Object> p1);
    boolean canHandle(URI p0);
    boolean exists(URI p0, Map<? extends Object, ? extends Object> p1);
    static List<URIHandler> DEFAULT_HANDLERS = null;
    void delete(URI p0, Map<? extends Object, ? extends Object> p1);
    void setAttributes(URI p0, Map<String, ? extends Object> p1, Map<? extends Object, ? extends Object> p2);
}
