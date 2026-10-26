// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core;

import java.io.Closeable;
import java.io.OutputStream;
import java.io.Writer;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Iterator;
import org.apache.htrace.shaded.fasterxml.jackson.core.Base64Variant;
import org.apache.htrace.shaded.fasterxml.jackson.core.FormatSchema;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonLocation;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParseException;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonStreamContext;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonToken;
import org.apache.htrace.shaded.fasterxml.jackson.core.ObjectCodec;
import org.apache.htrace.shaded.fasterxml.jackson.core.SerializableString;
import org.apache.htrace.shaded.fasterxml.jackson.core.TreeNode;
import org.apache.htrace.shaded.fasterxml.jackson.core.Version;
import org.apache.htrace.shaded.fasterxml.jackson.core.Versioned;
import org.apache.htrace.shaded.fasterxml.jackson.core.type.TypeReference;

abstract public class JsonParser implements Closeable, Versioned
{
    protected JsonParseException _constructError(String p0){ return null; }
    protected JsonParser(){}
    protected JsonParser(int p0){}
    protected ObjectCodec _codec(){ return null; }
    protected int _features = 0;
    protected void _reportUnsupportedOperation(){}
    public <T extends TreeNode> T readValueAsTree(){ return null; }
    public <T> T readValueAs(TypeReference<? extends Object> p0){ return null; }
    public <T> T readValueAs(java.lang.Class<T> p0){ return null; }
    public <T> java.util.Iterator<T> readValuesAs(TypeReference<? extends Object> p0){ return null; }
    public <T> java.util.Iterator<T> readValuesAs(java.lang.Class<T> p0){ return null; }
    public Boolean nextBooleanValue(){ return null; }
    public FormatSchema getSchema(){ return null; }
    public JsonParser configure(JsonParser.Feature p0, boolean p1){ return null; }
    public JsonParser disable(JsonParser.Feature p0){ return null; }
    public JsonParser enable(JsonParser.Feature p0){ return null; }
    public JsonParser setFeatureMask(int p0){ return null; }
    public Object getInputSource(){ return null; }
    public Object getObjectId(){ return null; }
    public Object getTypeId(){ return null; }
    public String getValueAsString(){ return null; }
    public String nextTextValue(){ return null; }
    public abstract BigDecimal getDecimalValue();
    public abstract BigInteger getBigIntegerValue();
    public abstract JsonLocation getCurrentLocation();
    public abstract JsonLocation getTokenLocation();
    public abstract JsonParser skipChildren();
    public abstract JsonParser.NumberType getNumberType();
    public abstract JsonStreamContext getParsingContext();
    public abstract JsonToken getCurrentToken();
    public abstract JsonToken getLastClearedToken();
    public abstract JsonToken nextToken();
    public abstract JsonToken nextValue();
    public abstract Number getNumberValue();
    public abstract Object getEmbeddedObject();
    public abstract ObjectCodec getCodec();
    public abstract String getCurrentName();
    public abstract String getText();
    public abstract String getValueAsString(String p0);
    public abstract Version version();
    public abstract boolean hasCurrentToken();
    public abstract boolean hasTextCharacters();
    public abstract boolean isClosed();
    public abstract byte[] getBinaryValue(Base64Variant p0);
    public abstract char[] getTextCharacters();
    public abstract double getDoubleValue();
    public abstract float getFloatValue();
    public abstract int getCurrentTokenId();
    public abstract int getIntValue();
    public abstract int getTextLength();
    public abstract int getTextOffset();
    public abstract long getLongValue();
    public abstract void clearCurrentToken();
    public abstract void close();
    public abstract void overrideCurrentName(String p0);
    public abstract void setCodec(ObjectCodec p0);
    public boolean canReadObjectId(){ return false; }
    public boolean canReadTypeId(){ return false; }
    public boolean canUseSchema(FormatSchema p0){ return false; }
    public boolean getBooleanValue(){ return false; }
    public boolean getValueAsBoolean(){ return false; }
    public boolean getValueAsBoolean(boolean p0){ return false; }
    public boolean isEnabled(JsonParser.Feature p0){ return false; }
    public boolean isExpectedStartArrayToken(){ return false; }
    public boolean nextFieldName(SerializableString p0){ return false; }
    public boolean requiresCustomCodec(){ return false; }
    public byte getByteValue(){ return 0; }
    public byte[] getBinaryValue(){ return null; }
    public double getValueAsDouble(){ return 0; }
    public double getValueAsDouble(double p0){ return 0; }
    public int getFeatureMask(){ return 0; }
    public int getValueAsInt(){ return 0; }
    public int getValueAsInt(int p0){ return 0; }
    public int nextIntValue(int p0){ return 0; }
    public int readBinaryValue(Base64Variant p0, OutputStream p1){ return 0; }
    public int readBinaryValue(OutputStream p0){ return 0; }
    public int releaseBuffered(OutputStream p0){ return 0; }
    public int releaseBuffered(Writer p0){ return 0; }
    public long getValueAsLong(){ return 0; }
    public long getValueAsLong(long p0){ return 0; }
    public long nextLongValue(long p0){ return 0; }
    public short getShortValue(){ return 0; }
    public void setSchema(FormatSchema p0){}
    static public enum Feature
    {
        ALLOW_BACKSLASH_ESCAPING_ANY_CHARACTER, ALLOW_COMMENTS, ALLOW_NON_NUMERIC_NUMBERS, ALLOW_NUMERIC_LEADING_ZEROS, ALLOW_SINGLE_QUOTES, ALLOW_UNQUOTED_CONTROL_CHARS, ALLOW_UNQUOTED_FIELD_NAMES, ALLOW_YAML_COMMENTS, AUTO_CLOSE_SOURCE, STRICT_DUPLICATE_DETECTION;
        private Feature() {}
        public boolean enabledByDefault(){ return false; }
        public boolean enabledIn(int p0){ return false; }
        public int getMask(){ return 0; }
        public static int collectDefaults(){ return 0; }
    }
    static public enum NumberType
    {
        BIG_DECIMAL, BIG_INTEGER, DOUBLE, FLOAT, INT, LONG;
        private NumberType() {}
    }
}
