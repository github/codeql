// Generated automatically from org.springframework.http.server.PathContainer for testing purposes

package org.springframework.http.server;

import java.util.List;

public interface PathContainer
{
    List<PathContainer.Element> elements();
    String value();
    default PathContainer subPath(int p0){ return null; }
    default PathContainer subPath(int p0, int p1){ return null; }
    static PathContainer parsePath(String p0){ return null; }
    static PathContainer parsePath(String p0, PathContainer.Options p1){ return null; }
    static public class Options
    {
        protected Options() {}
        public boolean shouldDecodeAndParseSegments(){ return false; }
        public char separator(){ return '0'; }
        public static PathContainer.Options HTTP_PATH = null;
        public static PathContainer.Options MESSAGE_ROUTE = null;
        public static PathContainer.Options create(char p0, boolean p1){ return null; }
    }
    static public interface Element
    {
        String value();
    }
}
