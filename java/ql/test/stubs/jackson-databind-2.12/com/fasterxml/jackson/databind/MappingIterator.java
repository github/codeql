package com.fasterxml.jackson.databind;

import java.io.Closeable;
import java.io.IOException;
import java.util.*;

public class MappingIterator<T> implements Iterator<T>, Closeable {

    @Override
    public boolean hasNext() {
        return false;
    }

    @Override
    public T next() {
        return null;
    }

    @Override
    public void remove() {
        
    }

    @Override
    public void close() throws IOException {
        
    }

    public List<T> readAll() {
        return null;
    }
}
