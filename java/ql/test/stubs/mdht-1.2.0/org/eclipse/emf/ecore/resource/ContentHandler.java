// Generated automatically from org.eclipse.emf.ecore.resource.ContentHandler for testing purposes

package org.eclipse.emf.ecore.resource;

import java.io.InputStream;
import java.util.Map;
import org.eclipse.emf.common.util.URI;

public interface ContentHandler
{
    Map<String, ? extends Object> contentDescription(URI p0, InputStream p1, Map<? extends Object, ? extends Object> p2, Map<Object, Object> p3);
    boolean canHandle(URI p0);
    static Map<String, Object> INVALID_CONTENT_DESCRIPTION = null;
    static String BYTE_ORDER_MARK_PROPERTY = null;
    static String CHARSET_PROPERTY = null;
    static String CONTENT_TYPE_PROPERTY = null;
    static String OPTION_REQUESTED_PROPERTIES = null;
    static String UNSPECIFIED_CONTENT_TYPE = null;
    static String VALIDITY_PROPERTY = null;
}
