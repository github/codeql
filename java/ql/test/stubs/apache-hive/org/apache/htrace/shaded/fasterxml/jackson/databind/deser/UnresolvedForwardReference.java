// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.deser.UnresolvedForwardReference for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.deser;

import java.util.List;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonLocation;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonMappingException;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.UnresolvedId;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.impl.ReadableObjectId;

public class UnresolvedForwardReference extends JsonMappingException
{
    protected UnresolvedForwardReference() {}
    public List<UnresolvedId> getUnresolvedIds(){ return null; }
    public Object getUnresolvedId(){ return null; }
    public ReadableObjectId getRoid(){ return null; }
    public String getMessage(){ return null; }
    public UnresolvedForwardReference(String p0){}
    public UnresolvedForwardReference(String p0, JsonLocation p1, ReadableObjectId p2){}
    public void addUnresolvedId(Object p0, Class<? extends Object> p1, JsonLocation p2){}
}
