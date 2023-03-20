// Generated automatically from org.kohsuke.stapler.FunctionList for testing purposes

package org.kohsuke.stapler;

import java.lang.annotation.Annotation;
import java.util.AbstractList;
import java.util.Collection;
import org.kohsuke.stapler.Function;

public class FunctionList extends AbstractList<Function>
{
    protected FunctionList() {}
    public Function get(int p0){ return null; }
    public FunctionList annotated(Class<? extends Annotation> p0){ return null; }
    public FunctionList name(String p0){ return null; }
    public FunctionList prefix(String p0){ return null; }
    public FunctionList signature(Class... p0){ return null; }
    public FunctionList signatureStartsWith(Class... p0){ return null; }
    public FunctionList union(FunctionList p0){ return null; }
    public FunctionList webMethodsLegacy(){ return null; }
    public FunctionList(Collection<Function> p0){}
    public FunctionList(Function... p0){}
    public int size(){ return 0; }
    static public interface Filter
    {
        boolean keep(Function p0);
        static FunctionList.Filter ALWAYS_OK = null;
    }
}
