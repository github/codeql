// Generated automatically from org.eclipse.emf.ecore.resource.URIConverter for testing purposes

package org.eclipse.emf.ecore.resource;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.ContentHandler;
import org.eclipse.emf.ecore.resource.URIHandler;

public interface URIConverter
{
    EList<ContentHandler> getContentHandlers();
    EList<URIHandler> getURIHandlers();
    InputStream createInputStream(URI p0);
    InputStream createInputStream(URI p0, Map<? extends Object, ? extends Object> p1);
    Map<String, ? extends Object> contentDescription(URI p0, Map<? extends Object, ? extends Object> p1);
    Map<String, ? extends Object> getAttributes(URI p0, Map<? extends Object, ? extends Object> p1);
    Map<URI, URI> getURIMap();
    OutputStream createOutputStream(URI p0);
    OutputStream createOutputStream(URI p0, Map<? extends Object, ? extends Object> p1);
    URI normalize(URI p0);
    URIHandler getURIHandler(URI p0);
    boolean exists(URI p0, Map<? extends Object, ? extends Object> p1);
    static Map<URI, URI> URI_MAP = null;
    static String ATTRIBUTE_ARCHIVE = null;
    static String ATTRIBUTE_DIRECTORY = null;
    static String ATTRIBUTE_EXECUTABLE = null;
    static String ATTRIBUTE_HIDDEN = null;
    static String ATTRIBUTE_LENGTH = null;
    static String ATTRIBUTE_READ_ONLY = null;
    static String ATTRIBUTE_TIME_STAMP = null;
    static String OPTION_REQUESTED_ATTRIBUTES = null;
    static String OPTION_RESPONSE = null;
    static String OPTION_URI_CONVERTER = null;
    static String RESPONSE_TIME_STAMP_PROPERTY = null;
    static String RESPONSE_URI = null;
    static URIConverter INSTANCE = null;
    static long NULL_TIME_STAMP = 0;
    void delete(URI p0, Map<? extends Object, ? extends Object> p1);
    void setAttributes(URI p0, Map<String, ? extends Object> p1, Map<? extends Object, ? extends Object> p2);
}
