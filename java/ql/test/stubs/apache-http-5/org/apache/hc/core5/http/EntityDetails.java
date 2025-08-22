// Generated automatically from org.apache.hc.core5.http.EntityDetails for testing purposes

package org.apache.hc.core5.http;

import java.util.Set;

public interface EntityDetails
{
    Set<String> getTrailerNames();
    String getContentEncoding();
    String getContentType();
    boolean isChunked();
    long getContentLength();
}
