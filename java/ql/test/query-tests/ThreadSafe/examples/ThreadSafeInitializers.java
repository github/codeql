package examples;

import java.util.Map;
import java.util.Set;
import java.util.HashMap;
import java.util.Collections;
import java.util.concurrent.ConcurrentHashMap;

@ThreadSafe
public class ThreadSafeInitializers {

    private int y;
    private final Map<Integer, Integer> sync_map;
    private final Map<Integer, Integer> sync_map_initialised = Collections.synchronizedMap(new HashMap<Integer, Integer>());

    
    private final Map<String, String> cmap;
    private final Map<String, String> cmap_initialised = new ConcurrentHashMap();
    private final Set<Integer> set;
    private final Set<Integer> set_initialised = ConcurrentHashMap.newKeySet();
    
    public ThreadSafeInitializers() {
        sync_map = Collections.synchronizedMap(new HashMap<Integer, Integer>());
        cmap = new ConcurrentHashMap();
        set = ConcurrentHashMap.newKeySet();
    }

    public void sync_map_put(Integer i, Integer v) {
        sync_map.put(i,v);
    }

    public void sync_map_initialised_put(Integer i, Integer v) {
        sync_map_initialised.put(i,v);
    }

    public void cmap_put(String s1, String s2) {
        cmap.put(s1, s2);
    }

    public void cmap_initialised_put(String s1, String s2) {
        cmap_initialised.put(s1, s2);
    }

    public void setY(int y) {
        this.y = y; // $ Alert
    }

    public void set_add(Integer i) {
        set.add(i);
    }

    public void set_initialised_add(Integer i) {
        set_initialised.add(i);
    }
}