// Generated automatically from io.netty.handler.codec.http2.Http2Headers for testing purposes

package io.netty.handler.codec.http2;

import io.netty.handler.codec.Headers;
import java.util.Iterator;
import java.util.Map;

public interface Http2Headers extends Headers<CharSequence, CharSequence, Http2Headers>
{
    CharSequence authority();
    CharSequence method();
    CharSequence path();
    CharSequence scheme();
    CharSequence status();
    Http2Headers authority(CharSequence p0);
    Http2Headers method(CharSequence p0);
    Http2Headers path(CharSequence p0);
    Http2Headers scheme(CharSequence p0);
    Http2Headers status(CharSequence p0);
    Iterator<CharSequence> valueIterator(CharSequence p0);
    Iterator<Map.Entry<CharSequence, CharSequence>> iterator();
    boolean contains(CharSequence p0, CharSequence p1, boolean p2);
}
