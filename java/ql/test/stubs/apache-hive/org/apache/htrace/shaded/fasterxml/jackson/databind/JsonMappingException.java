// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.JsonMappingException for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.io.IOException;
import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonLocation;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonProcessingException;

public class JsonMappingException extends JsonProcessingException
{
    protected JsonMappingException() {}
    protected LinkedList<JsonMappingException.Reference> _path = null;
    protected String _buildMessage(){ return null; }
    protected void _appendPathDesc(StringBuilder p0){}
    public JsonMappingException(String p0){}
    public JsonMappingException(String p0, JsonLocation p1){}
    public JsonMappingException(String p0, JsonLocation p1, Throwable p2){}
    public JsonMappingException(String p0, Throwable p1){}
    public List<JsonMappingException.Reference> getPath(){ return null; }
    public String getLocalizedMessage(){ return null; }
    public String getMessage(){ return null; }
    public String getPathReference(){ return null; }
    public String toString(){ return null; }
    public StringBuilder getPathReference(StringBuilder p0){ return null; }
    public static JsonMappingException from(JsonParser p0, String p1){ return null; }
    public static JsonMappingException from(JsonParser p0, String p1, Throwable p2){ return null; }
    public static JsonMappingException fromUnexpectedIOE(IOException p0){ return null; }
    public static JsonMappingException wrapWithPath(Throwable p0, JsonMappingException.Reference p1){ return null; }
    public static JsonMappingException wrapWithPath(Throwable p0, Object p1, String p2){ return null; }
    public static JsonMappingException wrapWithPath(Throwable p0, Object p1, int p2){ return null; }
    public void prependPath(JsonMappingException.Reference p0){}
    public void prependPath(Object p0, String p1){}
    public void prependPath(Object p0, int p1){}
    static public class Reference implements Serializable
    {
        protected Object _from = null;
        protected Reference(){}
        protected String _fieldName = null;
        protected int _index = 0;
        public Object getFrom(){ return null; }
        public Reference(Object p0){}
        public Reference(Object p0, String p1){}
        public Reference(Object p0, int p1){}
        public String getFieldName(){ return null; }
        public String toString(){ return null; }
        public int getIndex(){ return 0; }
        public void setFieldName(String p0){}
        public void setFrom(Object p0){}
        public void setIndex(int p0){}
    }
}
