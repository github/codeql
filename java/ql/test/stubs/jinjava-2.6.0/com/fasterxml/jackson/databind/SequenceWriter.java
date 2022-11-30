// Generated automatically from com.fasterxml.jackson.databind.SequenceWriter for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.Versioned;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.ser.DefaultSerializerProvider;
import com.fasterxml.jackson.databind.ser.impl.PropertySerializerMap;
import java.io.Closeable;
import java.io.Flushable;
import java.util.Collection;

public class SequenceWriter implements Closeable, Flushable, Versioned
{
    protected SequenceWriter() {}
    protected PropertySerializerMap _dynamicSerializers = null;
    protected SequenceWriter _writeCloseableValue(Object p0){ return null; }
    protected SequenceWriter _writeCloseableValue(Object p0, JavaType p1){ return null; }
    protected boolean _closed = false;
    protected boolean _openArray = false;
    protected final DefaultSerializerProvider _provider = null;
    protected final JsonGenerator _generator = null;
    protected final JsonSerializer<Object> _rootSerializer = null;
    protected final SerializationConfig _config = null;
    protected final TypeSerializer _typeSerializer = null;
    protected final boolean _cfgCloseCloseable = false;
    protected final boolean _cfgFlush = false;
    protected final boolean _closeGenerator = false;
    public <C extends Collection<? extends Object>> SequenceWriter writeAll(C p0){ return null; }
    public SequenceWriter init(boolean p0){ return null; }
    public SequenceWriter write(Object p0){ return null; }
    public SequenceWriter write(Object p0, JavaType p1){ return null; }
    public SequenceWriter writeAll(Iterable<? extends Object> p0){ return null; }
    public SequenceWriter writeAll(Object[] p0){ return null; }
    public SequenceWriter(DefaultSerializerProvider p0, JsonGenerator p1, boolean p2, ObjectWriter.Prefetch p3){}
    public Version version(){ return null; }
    public void close(){}
    public void flush(){}
}
