// Generated automatically from com.fasterxml.jackson.core.JsonFactory for testing purposes

package com.fasterxml.jackson.core;

import com.fasterxml.jackson.core.FormatFeature;
import com.fasterxml.jackson.core.FormatSchema;
import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.core.SerializableString;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.Versioned;
import com.fasterxml.jackson.core.format.InputAccessor;
import com.fasterxml.jackson.core.format.MatchStrength;
import com.fasterxml.jackson.core.io.CharacterEscapes;
import com.fasterxml.jackson.core.io.IOContext;
import com.fasterxml.jackson.core.io.InputDecorator;
import com.fasterxml.jackson.core.io.OutputDecorator;
import com.fasterxml.jackson.core.sym.ByteQuadsCanonicalizer;
import com.fasterxml.jackson.core.sym.CharsToNameCanonicalizer;
import com.fasterxml.jackson.core.util.BufferRecycler;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Serializable;
import java.io.Writer;
import java.lang.ref.SoftReference;
import java.net.URL;

public class JsonFactory implements Serializable, Versioned
{
    protected CharacterEscapes _characterEscapes = null;
    protected IOContext _createContext(Object p0, boolean p1){ return null; }
    protected InputDecorator _inputDecorator = null;
    protected InputStream _optimizedStreamFromURL(URL p0){ return null; }
    protected JsonFactory(JsonFactory p0, ObjectCodec p1){}
    protected JsonGenerator _createGenerator(Writer p0, IOContext p1){ return null; }
    protected JsonGenerator _createUTF8Generator(OutputStream p0, IOContext p1){ return null; }
    protected JsonParser _createParser(InputStream p0, IOContext p1){ return null; }
    protected JsonParser _createParser(Reader p0, IOContext p1){ return null; }
    protected JsonParser _createParser(byte[] p0, int p1, int p2, IOContext p3){ return null; }
    protected JsonParser _createParser(char[] p0, int p1, int p2, IOContext p3, boolean p4){ return null; }
    protected MatchStrength hasJSONFormat(InputAccessor p0){ return null; }
    protected Object readResolve(){ return null; }
    protected ObjectCodec _objectCodec = null;
    protected OutputDecorator _outputDecorator = null;
    protected SerializableString _rootValueSeparator = null;
    protected Writer _createWriter(OutputStream p0, JsonEncoding p1, IOContext p2){ return null; }
    protected final ByteQuadsCanonicalizer _byteSymbolCanonicalizer = null;
    protected final CharsToNameCanonicalizer _rootCharSymbols = null;
    protected final InputStream _decorate(InputStream p0, IOContext p1){ return null; }
    protected final OutputStream _decorate(OutputStream p0, IOContext p1){ return null; }
    protected final Reader _decorate(Reader p0, IOContext p1){ return null; }
    protected final Writer _decorate(Writer p0, IOContext p1){ return null; }
    protected int _factoryFeatures = 0;
    protected int _generatorFeatures = 0;
    protected int _parserFeatures = 0;
    protected static ThreadLocal<SoftReference<BufferRecycler>> _recyclerRef = null;
    protected static int DEFAULT_FACTORY_FEATURE_FLAGS = 0;
    protected static int DEFAULT_GENERATOR_FEATURE_FLAGS = 0;
    protected static int DEFAULT_PARSER_FEATURE_FLAGS = 0;
    protected void _checkInvalidCopy(Class<? extends Object> p0){}
    public BufferRecycler _getBufferRecycler(){ return null; }
    public CharacterEscapes getCharacterEscapes(){ return null; }
    public Class<? extends FormatFeature> getFormatReadFeatureType(){ return null; }
    public Class<? extends FormatFeature> getFormatWriteFeatureType(){ return null; }
    public InputDecorator getInputDecorator(){ return null; }
    public JsonFactory copy(){ return null; }
    public JsonFactory disable(JsonFactory.Feature p0){ return null; }
    public JsonFactory disable(JsonGenerator.Feature p0){ return null; }
    public JsonFactory disable(JsonParser.Feature p0){ return null; }
    public JsonFactory enable(JsonFactory.Feature p0){ return null; }
    public JsonFactory enable(JsonGenerator.Feature p0){ return null; }
    public JsonFactory enable(JsonParser.Feature p0){ return null; }
    public JsonFactory setCharacterEscapes(CharacterEscapes p0){ return null; }
    public JsonFactory setCodec(ObjectCodec p0){ return null; }
    public JsonFactory setInputDecorator(InputDecorator p0){ return null; }
    public JsonFactory setOutputDecorator(OutputDecorator p0){ return null; }
    public JsonFactory setRootValueSeparator(String p0){ return null; }
    public JsonFactory(){}
    public JsonFactory(ObjectCodec p0){}
    public JsonGenerator createGenerator(File p0, JsonEncoding p1){ return null; }
    public JsonGenerator createGenerator(OutputStream p0){ return null; }
    public JsonGenerator createGenerator(OutputStream p0, JsonEncoding p1){ return null; }
    public JsonGenerator createGenerator(Writer p0){ return null; }
    public JsonGenerator createJsonGenerator(OutputStream p0){ return null; }
    public JsonGenerator createJsonGenerator(OutputStream p0, JsonEncoding p1){ return null; }
    public JsonGenerator createJsonGenerator(Writer p0){ return null; }
    public JsonParser createJsonParser(File p0){ return null; }
    public JsonParser createJsonParser(InputStream p0){ return null; }
    public JsonParser createJsonParser(Reader p0){ return null; }
    public JsonParser createJsonParser(String p0){ return null; }
    public JsonParser createJsonParser(URL p0){ return null; }
    public JsonParser createJsonParser(byte[] p0){ return null; }
    public JsonParser createJsonParser(byte[] p0, int p1, int p2){ return null; }
    public JsonParser createParser(File p0){ return null; }
    public JsonParser createParser(InputStream p0){ return null; }
    public JsonParser createParser(Reader p0){ return null; }
    public JsonParser createParser(String p0){ return null; }
    public JsonParser createParser(URL p0){ return null; }
    public JsonParser createParser(byte[] p0){ return null; }
    public JsonParser createParser(byte[] p0, int p1, int p2){ return null; }
    public JsonParser createParser(char[] p0){ return null; }
    public JsonParser createParser(char[] p0, int p1, int p2){ return null; }
    public MatchStrength hasFormat(InputAccessor p0){ return null; }
    public ObjectCodec getCodec(){ return null; }
    public OutputDecorator getOutputDecorator(){ return null; }
    public String getFormatName(){ return null; }
    public String getRootValueSeparator(){ return null; }
    public Version version(){ return null; }
    public boolean canHandleBinaryNatively(){ return false; }
    public boolean canUseCharArrays(){ return false; }
    public boolean canUseSchema(FormatSchema p0){ return false; }
    public boolean requiresCustomCodec(){ return false; }
    public boolean requiresPropertyOrdering(){ return false; }
    public final JsonFactory configure(JsonFactory.Feature p0, boolean p1){ return null; }
    public final JsonFactory configure(JsonGenerator.Feature p0, boolean p1){ return null; }
    public final JsonFactory configure(JsonParser.Feature p0, boolean p1){ return null; }
    public final boolean isEnabled(JsonFactory.Feature p0){ return false; }
    public final boolean isEnabled(JsonGenerator.Feature p0){ return false; }
    public final boolean isEnabled(JsonParser.Feature p0){ return false; }
    public static String FORMAT_NAME_JSON = null;
    static public enum Feature
    {
        CANONICALIZE_FIELD_NAMES, FAIL_ON_SYMBOL_HASH_OVERFLOW, INTERN_FIELD_NAMES, USE_THREAD_LOCAL_FOR_BUFFER_RECYCLING;
        private Feature() {}
        public boolean enabledByDefault(){ return false; }
        public boolean enabledIn(int p0){ return false; }
        public int getMask(){ return 0; }
        public static int collectDefaults(){ return 0; }
    }
}
