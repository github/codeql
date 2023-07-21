// Generated automatically from org.springframework.util.MimeType for testing purposes

package org.springframework.util;

import java.io.Serializable;
import java.nio.charset.Charset;
import java.util.Collection;
import java.util.Map;

public class MimeType implements Comparable<MimeType>, Serializable
{
    protected MimeType() {}
    protected MimeType(MimeType p0){}
    protected String unquote(String p0){ return null; }
    protected static String WILDCARD_TYPE = null;
    protected void appendTo(StringBuilder p0){}
    protected void checkParameters(String p0, String p1){}
    public Charset getCharset(){ return null; }
    public Map<String, String> getParameters(){ return null; }
    public MimeType(MimeType p0, Charset p1){}
    public MimeType(MimeType p0, Map<String, String> p1){}
    public MimeType(String p0){}
    public MimeType(String p0, String p1){}
    public MimeType(String p0, String p1, Charset p2){}
    public MimeType(String p0, String p1, Map<String, String> p2){}
    public String getParameter(String p0){ return null; }
    public String getSubtype(){ return null; }
    public String getSubtypeSuffix(){ return null; }
    public String getType(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean equalsTypeAndSubtype(MimeType p0){ return false; }
    public boolean includes(MimeType p0){ return false; }
    public boolean isCompatibleWith(MimeType p0){ return false; }
    public boolean isConcrete(){ return false; }
    public boolean isLessSpecific(MimeType p0){ return false; }
    public boolean isMoreSpecific(MimeType p0){ return false; }
    public boolean isPresentIn(Collection<? extends MimeType> p0){ return false; }
    public boolean isWildcardSubtype(){ return false; }
    public boolean isWildcardType(){ return false; }
    public int compareTo(MimeType p0){ return 0; }
    public int hashCode(){ return 0; }
    public static MimeType valueOf(String p0){ return null; }
}
