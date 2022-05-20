package com.esotericsoftware.kryo.pool;

import com.esotericsoftware.kryo.Kryo;
import java.util.Queue;

public interface KryoPool {

    Kryo borrow ();

    void release (Kryo kryo);

    <T> T run (KryoCallback<T> callback);

    static class Builder {
        public Builder (KryoFactory factory) {
        }
    
        public Builder queue (Queue<Kryo> queue) {
            return null;
        }
    
        public Builder softReferences () {
            return null;
        }
    
        public KryoPool build () {
            return null;
        }
    }
}
