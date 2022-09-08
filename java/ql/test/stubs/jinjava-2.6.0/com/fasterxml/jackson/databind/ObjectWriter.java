// Generated automatically from com.fasterxml.jackson.databind.ObjectWriter for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.Base64Variant;
import com.fasterxml.jackson.core.FormatFeature;
import com.fasterxml.jackson.core.FormatSchema;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.PrettyPrinter;
import com.fasterxml.jackson.core.SerializableString;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.Versioned;
import com.fasterxml.jackson.core.io.CharacterEscapes;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.SequenceWriter;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.ser.DefaultSerializerProvider;
import com.fasterxml.jackson.databind.ser.FilterProvider;
import com.fasterxml.jackson.databind.ser.SerializerFactory;
import com.fasterxml.jackson.databind.type.TypeFactory;
import java.io.File;
import java.io.OutputStream;
import java.io.Serializable;
import java.io.Writer;
import java.text.DateFormat;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.concurrent.atomic.AtomicReference;

public class ObjectWriter implements Serializable, Versioned
{
    protected ObjectWriter() {}
    protected DefaultSerializerProvider _serializerProvider(){ return null; }
    protected ObjectWriter _new(ObjectWriter p0, JsonFactory p1){ return null; }
    protected ObjectWriter _new(ObjectWriter p0, SerializationConfig p1){ return null; }
    protected ObjectWriter _new(ObjectWriter.GeneratorSettings p0, ObjectWriter.Prefetch p1){ return null; }
    protected ObjectWriter(ObjectMapper p0, SerializationConfig p1){}
    protected ObjectWriter(ObjectMapper p0, SerializationConfig p1, FormatSchema p2){}
    protected ObjectWriter(ObjectMapper p0, SerializationConfig p1, JavaType p2, PrettyPrinter p3){}
    protected ObjectWriter(ObjectWriter p0, JsonFactory p1){}
    protected ObjectWriter(ObjectWriter p0, SerializationConfig p1){}
    protected ObjectWriter(ObjectWriter p0, SerializationConfig p1, ObjectWriter.GeneratorSettings p2, ObjectWriter.Prefetch p3){}
    protected SequenceWriter _newSequenceWriter(boolean p0, JsonGenerator p1, boolean p2){ return null; }
    protected final DefaultSerializerProvider _serializerProvider = null;
    protected final JsonFactory _generatorFactory = null;
    protected final ObjectWriter.GeneratorSettings _generatorSettings = null;
    protected final ObjectWriter.Prefetch _prefetch = null;
    protected final SerializationConfig _config = null;
    protected final SerializerFactory _serializerFactory = null;
    protected final void _configAndWriteValue(JsonGenerator p0, Object p1){}
    protected final void _configureGenerator(JsonGenerator p0){}
    protected static PrettyPrinter NULL_PRETTY_PRINTER = null;
    protected void _verifySchemaType(FormatSchema p0){}
    public ContextAttributes getAttributes(){ return null; }
    public JsonFactory getFactory(){ return null; }
    public ObjectWriter forType(Class<? extends Object> p0){ return null; }
    public ObjectWriter forType(JavaType p0){ return null; }
    public ObjectWriter forType(TypeReference<? extends Object> p0){ return null; }
    public ObjectWriter with(Base64Variant p0){ return null; }
    public ObjectWriter with(CharacterEscapes p0){ return null; }
    public ObjectWriter with(ContextAttributes p0){ return null; }
    public ObjectWriter with(DateFormat p0){ return null; }
    public ObjectWriter with(FilterProvider p0){ return null; }
    public ObjectWriter with(FormatFeature p0){ return null; }
    public ObjectWriter with(FormatSchema p0){ return null; }
    public ObjectWriter with(JsonFactory p0){ return null; }
    public ObjectWriter with(JsonGenerator.Feature p0){ return null; }
    public ObjectWriter with(Locale p0){ return null; }
    public ObjectWriter with(PrettyPrinter p0){ return null; }
    public ObjectWriter with(SerializationFeature p0){ return null; }
    public ObjectWriter with(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public ObjectWriter with(TimeZone p0){ return null; }
    public ObjectWriter withAttribute(Object p0, Object p1){ return null; }
    public ObjectWriter withAttributes(Map<? extends Object, ? extends Object> p0){ return null; }
    public ObjectWriter withDefaultPrettyPrinter(){ return null; }
    public ObjectWriter withFeatures(FormatFeature... p0){ return null; }
    public ObjectWriter withFeatures(JsonGenerator.Feature... p0){ return null; }
    public ObjectWriter withFeatures(SerializationFeature... p0){ return null; }
    public ObjectWriter withRootName(PropertyName p0){ return null; }
    public ObjectWriter withRootName(String p0){ return null; }
    public ObjectWriter withRootValueSeparator(SerializableString p0){ return null; }
    public ObjectWriter withRootValueSeparator(String p0){ return null; }
    public ObjectWriter withSchema(FormatSchema p0){ return null; }
    public ObjectWriter withType(Class<? extends Object> p0){ return null; }
    public ObjectWriter withType(JavaType p0){ return null; }
    public ObjectWriter withType(TypeReference<? extends Object> p0){ return null; }
    public ObjectWriter withView(Class<? extends Object> p0){ return null; }
    public ObjectWriter without(FormatFeature p0){ return null; }
    public ObjectWriter without(JsonGenerator.Feature p0){ return null; }
    public ObjectWriter without(SerializationFeature p0){ return null; }
    public ObjectWriter without(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public ObjectWriter withoutAttribute(Object p0){ return null; }
    public ObjectWriter withoutFeatures(FormatFeature... p0){ return null; }
    public ObjectWriter withoutFeatures(JsonGenerator.Feature... p0){ return null; }
    public ObjectWriter withoutFeatures(SerializationFeature... p0){ return null; }
    public ObjectWriter withoutRootName(){ return null; }
    public SequenceWriter writeValues(File p0){ return null; }
    public SequenceWriter writeValues(JsonGenerator p0){ return null; }
    public SequenceWriter writeValues(OutputStream p0){ return null; }
    public SequenceWriter writeValues(Writer p0){ return null; }
    public SequenceWriter writeValuesAsArray(File p0){ return null; }
    public SequenceWriter writeValuesAsArray(JsonGenerator p0){ return null; }
    public SequenceWriter writeValuesAsArray(OutputStream p0){ return null; }
    public SequenceWriter writeValuesAsArray(Writer p0){ return null; }
    public SerializationConfig getConfig(){ return null; }
    public String writeValueAsString(Object p0){ return null; }
    public TypeFactory getTypeFactory(){ return null; }
    public Version version(){ return null; }
    public boolean canSerialize(Class<? extends Object> p0){ return false; }
    public boolean canSerialize(Class<? extends Object> p0, AtomicReference<Throwable> p1){ return false; }
    public boolean hasPrefetchedSerializer(){ return false; }
    public boolean isEnabled(JsonParser.Feature p0){ return false; }
    public boolean isEnabled(MapperFeature p0){ return false; }
    public boolean isEnabled(SerializationFeature p0){ return false; }
    public byte[] writeValueAsBytes(Object p0){ return null; }
    public void acceptJsonFormatVisitor(Class<? extends Object> p0, JsonFormatVisitorWrapper p1){}
    public void acceptJsonFormatVisitor(JavaType p0, JsonFormatVisitorWrapper p1){}
    public void writeValue(File p0, Object p1){}
    public void writeValue(JsonGenerator p0, Object p1){}
    public void writeValue(OutputStream p0, Object p1){}
    public void writeValue(Writer p0, Object p1){}
    static public class GeneratorSettings implements Serializable
    {
        protected GeneratorSettings() {}
        public GeneratorSettings(PrettyPrinter p0, FormatSchema p1, CharacterEscapes p2, SerializableString p3){}
        public ObjectWriter.GeneratorSettings with(CharacterEscapes p0){ return null; }
        public ObjectWriter.GeneratorSettings with(FormatSchema p0){ return null; }
        public ObjectWriter.GeneratorSettings with(PrettyPrinter p0){ return null; }
        public ObjectWriter.GeneratorSettings withRootValueSeparator(SerializableString p0){ return null; }
        public ObjectWriter.GeneratorSettings withRootValueSeparator(String p0){ return null; }
        public final CharacterEscapes characterEscapes = null;
        public final FormatSchema schema = null;
        public final PrettyPrinter prettyPrinter = null;
        public final SerializableString rootValueSeparator = null;
        public static ObjectWriter.GeneratorSettings empty = null;
        public void initialize(JsonGenerator p0){}
    }
    static public class Prefetch implements Serializable
    {
        protected Prefetch() {}
        public ObjectWriter.Prefetch forRootType(ObjectWriter p0, JavaType p1){ return null; }
        public boolean hasSerializer(){ return false; }
        public final JsonSerializer<Object> getValueSerializer(){ return null; }
        public final TypeSerializer getTypeSerializer(){ return null; }
        public static ObjectWriter.Prefetch empty = null;
        public void serialize(JsonGenerator p0, Object p1, DefaultSerializerProvider p2){}
    }
}
