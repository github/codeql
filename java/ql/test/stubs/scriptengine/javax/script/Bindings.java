package javax.script;
import java.util.Map;

public interface Bindings extends Map<String, Object> {
    public Object put(String name, Object value);

    public void putAll(Map<? extends String, ? extends Object> toMerge);

    public boolean containsKey(Object key);

    public Object get(Object key);

    public Object remove(Object key);
}
