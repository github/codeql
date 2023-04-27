// Generated automatically from org.kohsuke.stapler.Facet for testing purposes

package org.kohsuke.stapler;

import java.util.List;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import org.kohsuke.stapler.AbstractTearOff;
import org.kohsuke.stapler.Dispatcher;
import org.kohsuke.stapler.MetaClass;
import org.kohsuke.stapler.RequestImpl;
import org.kohsuke.stapler.ResponseImpl;
import org.kohsuke.stapler.ScriptExecutor;
import org.kohsuke.stapler.lang.Klass;

abstract public class Facet
{
    protected <S> Dispatcher createValidatingDispatcher(org.kohsuke.stapler.AbstractTearOff<? extends Object, ? extends S, ? extends Object> p0, org.kohsuke.stapler.ScriptExecutor<? super S> p1){ return null; }
    protected <S> RequestDispatcher createRequestDispatcher(org.kohsuke.stapler.AbstractTearOff<? extends Object, ? extends S, ? extends Object> p0, org.kohsuke.stapler.ScriptExecutor<? super S> p1, Object p2, String p3){ return null; }
    protected <S> boolean handleIndexRequest(org.kohsuke.stapler.AbstractTearOff<? extends Object, ? extends S, ? extends Object> p0, org.kohsuke.stapler.ScriptExecutor<? super S> p1, RequestImpl p2, ResponseImpl p3, Object p4){ return false; }
    protected String getExtensionSuffix(){ return null; }
    protected boolean isBasename(String p0){ return false; }
    public Facet(){}
    public Klass<? extends Object> getKlass(Object p0){ return null; }
    public RequestDispatcher createRequestDispatcher(RequestImpl p0, Class p1, Object p2, String p3){ return null; }
    public RequestDispatcher createRequestDispatcher(RequestImpl p0, Klass<? extends Object> p1, Object p2, String p3){ return null; }
    public abstract boolean handleIndexRequest(RequestImpl p0, ResponseImpl p1, Object p2, MetaClass p3);
    public abstract void buildViewDispatchers(MetaClass p0, List<Dispatcher> p1);
    public static <T> java.util.List<T> discoverExtensions(java.lang.Class<T> p0, ClassLoader... p1){ return null; }
    public static List<Facet> discover(ClassLoader p0){ return null; }
    public static Logger LOGGER = null;
    public static boolean ALLOW_VIEW_NAME_PATH_TRAVERSAL = false;
    public void buildFallbackDispatchers(MetaClass p0, List<Dispatcher> p1){}
    public void buildIndexDispatchers(MetaClass p0, List<Dispatcher> p1){}
}
