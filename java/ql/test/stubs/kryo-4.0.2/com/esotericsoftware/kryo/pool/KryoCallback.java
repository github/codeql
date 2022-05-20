package com.esotericsoftware.kryo.pool;

import com.esotericsoftware.kryo.Kryo;

public interface KryoCallback<T> {
	T execute (Kryo kryo);
}
