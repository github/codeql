// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.util.NameTransformer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.util;


abstract public class NameTransformer
{
    protected NameTransformer(){}
    public abstract String reverse(String p0);
    public abstract String transform(String p0);
    public static NameTransformer NOP = null;
    public static NameTransformer chainedTransformer(NameTransformer p0, NameTransformer p1){ return null; }
    public static NameTransformer simpleTransformer(String p0, String p1){ return null; }
}
