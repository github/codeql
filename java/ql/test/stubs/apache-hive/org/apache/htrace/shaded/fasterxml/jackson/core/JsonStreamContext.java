// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.JsonStreamContext for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core;


abstract public class JsonStreamContext
{
    protected JsonStreamContext(){}
    protected int _index = 0;
    protected int _type = 0;
    protected static int TYPE_ARRAY = 0;
    protected static int TYPE_OBJECT = 0;
    protected static int TYPE_ROOT = 0;
    public abstract JsonStreamContext getParent();
    public abstract String getCurrentName();
    public final String getTypeDesc(){ return null; }
    public final boolean inArray(){ return false; }
    public final boolean inObject(){ return false; }
    public final boolean inRoot(){ return false; }
    public final int getCurrentIndex(){ return 0; }
    public final int getEntryCount(){ return 0; }
}
