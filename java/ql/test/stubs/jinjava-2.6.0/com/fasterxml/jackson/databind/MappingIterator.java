// Generated automatically from com.fasterxml.jackson.databind.MappingIterator for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.FormatSchema;
import com.fasterxml.jackson.core.JsonLocation;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonStreamContext;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonMappingException;
import java.io.Closeable;
import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

public class MappingIterator<T> implements Closeable, Iterator<T>
{
    protected MappingIterator() {}
    protected <R> R _handleIOException(IOException p0){ return null; }
    protected <R> R _handleMappingException(JsonMappingException p0){ return null; }
    protected <R> R _throwNoSuchElement(){ return null; }
    protected MappingIterator(JavaType p0, JsonParser p1, DeserializationContext p2, JsonDeserializer<? extends Object> p3, boolean p4, Object p5){}
    protected final DeserializationContext _context = null;
    protected final JavaType _type = null;
    protected final JsonDeserializer<T> _deserializer = null;
    protected final JsonParser _parser = null;
    protected final JsonStreamContext _seqContext = null;
    protected final T _updatedValue = null;
    protected final boolean _closeParser = false;
    protected int _state = 0;
    protected static <T> MappingIterator<T> emptyIterator(){ return null; }
    protected static MappingIterator<? extends Object> EMPTY_ITERATOR = null;
    protected static int STATE_CLOSED = 0;
    protected static int STATE_HAS_VALUE = 0;
    protected static int STATE_MAY_HAVE_VALUE = 0;
    protected static int STATE_NEED_RESYNC = 0;
    protected void _resync(){}
    public <C extends Collection<? super T>> C readAll(C p0){ return null; }
    public <L extends List<? super T>> L readAll(L p0){ return null; }
    public FormatSchema getParserSchema(){ return null; }
    public JsonLocation getCurrentLocation(){ return null; }
    public JsonParser getParser(){ return null; }
    public List<T> readAll(){ return null; }
    public T next(){ return null; }
    public T nextValue(){ return null; }
    public boolean hasNext(){ return false; }
    public boolean hasNextValue(){ return false; }
    public void close(){}
    public void remove(){}
}
