// Generated automatically from org.apache.logging.log4j.message.MapMessage for testing purposes

package org.apache.logging.log4j.message;

import java.util.Map;
import org.apache.logging.log4j.util.BiConsumer;
import org.apache.logging.log4j.util.IndexedReadOnlyStringMap;
import org.apache.logging.log4j.util.MultiFormatStringBuilderFormattable;
import org.apache.logging.log4j.util.TriConsumer;

public class MapMessage<M extends MapMessage<M, V>, V> implements MultiFormatStringBuilderFormattable
{
    protected String toKey(String p0){ return null; }
    protected void appendMap(StringBuilder p0){}
    protected void asJava(StringBuilder p0){}
    protected void asJavaUnquoted(StringBuilder p0){}
    protected void asJson(StringBuilder p0){}
    protected void validate(String p0, Object p1){}
    protected void validate(String p0, String p1){}
    protected void validate(String p0, boolean p1){}
    protected void validate(String p0, byte p1){}
    protected void validate(String p0, char p1){}
    protected void validate(String p0, double p1){}
    protected void validate(String p0, float p1){}
    protected void validate(String p0, int p1){}
    protected void validate(String p0, long p1){}
    protected void validate(String p0, short p1){}
    public <CV, S> void forEach(TriConsumer<String, ? super CV, S> p0, S p1){}
    public <CV> void forEach(BiConsumer<String, ? super CV> p0){}
    public IndexedReadOnlyStringMap getIndexedReadOnlyStringMap(){ return null; }
    public M newInstance(Map<String, V> p0){ return null; }
    public M with(String p0, Object p1){ return null; }
    public M with(String p0, String p1){ return null; }
    public M with(String p0, boolean p1){ return null; }
    public M with(String p0, byte p1){ return null; }
    public M with(String p0, char p1){ return null; }
    public M with(String p0, double p1){ return null; }
    public M with(String p0, float p1){ return null; }
    public M with(String p0, int p1){ return null; }
    public M with(String p0, long p1){ return null; }
    public M with(String p0, short p1){ return null; }
    public Map<String, V> getData(){ return null; }
    public MapMessage(){}
    public MapMessage(Map<String, V> p0){}
    public MapMessage(int p0){}
    public Object[] getParameters(){ return null; }
    public String asString(){ return null; }
    public String asString(String p0){ return null; }
    public String get(String p0){ return null; }
    public String getFormat(){ return null; }
    public String getFormattedMessage(){ return null; }
    public String getFormattedMessage(String[] p0){ return null; }
    public String remove(String p0){ return null; }
    public String toString(){ return null; }
    public String[] getFormats(){ return null; }
    public Throwable getThrowable(){ return null; }
    public boolean containsKey(String p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public void asXml(StringBuilder p0){}
    public void clear(){}
    public void formatTo(StringBuilder p0){}
    public void formatTo(String[] p0, StringBuilder p1){}
    public void put(String p0, String p1){}
    public void putAll(Map<String, String> p0){}
}
