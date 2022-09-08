// Generated automatically from com.fasterxml.jackson.databind.deser.UnresolvedForwardReference for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.core.JsonLocation;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.deser.UnresolvedId;
import com.fasterxml.jackson.databind.deser.impl.ReadableObjectId;
import java.util.List;

public class UnresolvedForwardReference extends JsonMappingException
{
    protected UnresolvedForwardReference() {}
    public List<UnresolvedId> getUnresolvedIds(){ return null; }
    public Object getUnresolvedId(){ return null; }
    public ReadableObjectId getRoid(){ return null; }
    public String getMessage(){ return null; }
    public UnresolvedForwardReference(JsonParser p0, String p1){}
    public UnresolvedForwardReference(JsonParser p0, String p1, JsonLocation p2, ReadableObjectId p3){}
    public UnresolvedForwardReference(String p0){}
    public UnresolvedForwardReference(String p0, JsonLocation p1, ReadableObjectId p2){}
    public void addUnresolvedId(Object p0, Class<? extends Object> p1, JsonLocation p2){}
}
