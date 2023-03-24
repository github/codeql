// Generated automatically from org.apache.velocity.context.AbstractContext for testing purposes

package org.apache.velocity.context;

import org.apache.velocity.context.Context;
import org.apache.velocity.context.InternalContextBase;

abstract public class AbstractContext extends InternalContextBase implements Context
{
    public AbstractContext(){}
    public AbstractContext(Context p0){}
    public Context getChainedContext(){ return null; }
    public Object get(String p0){ return null; }
    public Object put(String p0, Object p1){ return null; }
    public Object remove(String p0){ return null; }
    public String[] getKeys(){ return null; }
    public abstract Object internalGet(String p0);
    public abstract Object internalPut(String p0, Object p1);
    public abstract Object internalRemove(String p0);
    public abstract String[] internalGetKeys();
    public abstract boolean internalContainsKey(String p0);
    public boolean containsKey(String p0){ return false; }
}
