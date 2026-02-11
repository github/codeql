// Generated automatically from org.springframework.http.HttpRange for testing purposes

package org.springframework.http;

import java.util.Collection;
import java.util.List;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.ResourceRegion;

abstract public class HttpRange
{
    public HttpRange(){}
    public ResourceRegion toResourceRegion(Resource p0){ return null; }
    public abstract long getRangeEnd(long p0);
    public abstract long getRangeStart(long p0);
    public static HttpRange createByteRange(long p0){ return null; }
    public static HttpRange createByteRange(long p0, long p1){ return null; }
    public static HttpRange createSuffixRange(long p0){ return null; }
    public static List<HttpRange> parseRanges(String p0){ return null; }
    public static List<ResourceRegion> toResourceRegions(List<HttpRange> p0, Resource p1){ return null; }
    public static String toString(Collection<HttpRange> p0){ return null; }
}
