// Generated automatically from org.apache.hc.core5.http.nio.HandlerFactory for testing purposes

package org.apache.hc.core5.http.nio;

import org.apache.hc.core5.http.HttpRequest;
import org.apache.hc.core5.http.nio.ResourceHolder;
import org.apache.hc.core5.http.protocol.HttpContext;

public interface HandlerFactory<T extends ResourceHolder>
{
    T create(HttpRequest p0, HttpContext p1);
}
