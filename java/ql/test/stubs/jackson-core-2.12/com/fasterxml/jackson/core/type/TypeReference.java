package com.fasterxml.jackson.core.type;

import java.lang.reflect.Type;

public abstract class TypeReference<T> implements Comparable<TypeReference<T>> {
    public Type getType() {
        return null;
    }

    @Override
    public int compareTo(TypeReference<T> o) {
        return 0;
    }

}
