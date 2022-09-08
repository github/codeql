// Generated automatically from jinjava.javax.el.ELContext for testing purposes

package jinjava.javax.el;

import java.util.Locale;
import jinjava.javax.el.ELResolver;
import jinjava.javax.el.FunctionMapper;
import jinjava.javax.el.VariableMapper;

abstract public class ELContext
{
    public ELContext(){}
    public Locale getLocale(){ return null; }
    public Object getContext(Class<? extends Object> p0){ return null; }
    public abstract ELResolver getELResolver();
    public abstract FunctionMapper getFunctionMapper();
    public abstract VariableMapper getVariableMapper();
    public boolean isPropertyResolved(){ return false; }
    public void putContext(Class<? extends Object> p0, Object p1){}
    public void setLocale(Locale p0){}
    public void setPropertyResolved(boolean p0){}
}
