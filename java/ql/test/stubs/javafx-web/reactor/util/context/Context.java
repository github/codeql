// Generated automatically from reactor.util.context.Context for testing purposes

package reactor.util.context;

import java.util.Map;
import reactor.util.context.ContextView;

public interface Context extends ContextView
{
    Context delete(Object p0);
    Context put(Object p0, Object p1);
    default Context putAll(Context p0){ return null; }
    default Context putAll(ContextView p0){ return null; }
    default Context putAllMap(Map<? extends Object, ? extends Object> p0){ return null; }
    default Context putNonNull(Object p0, Object p1){ return null; }
    default ContextView readOnly(){ return null; }
    static Context empty(){ return null; }
    static Context of(ContextView p0){ return null; }
    static Context of(Map<? extends Object, ? extends Object> p0){ return null; }
    static Context of(Object p0, Object p1){ return null; }
    static Context of(Object p0, Object p1, Object p2, Object p3){ return null; }
    static Context of(Object p0, Object p1, Object p2, Object p3, Object p4, Object p5){ return null; }
    static Context of(Object p0, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7){ return null; }
    static Context of(Object p0, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7, Object p8, Object p9){ return null; }
}
