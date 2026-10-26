// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core;

import java.io.Closeable;
import java.io.Flushable;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.BigInteger;
import org.apache.htrace.shaded.fasterxml.jackson.core.Base64Variant;
import org.apache.htrace.shaded.fasterxml.jackson.core.FormatSchema;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonStreamContext;
import org.apache.htrace.shaded.fasterxml.jackson.core.ObjectCodec;
import org.apache.htrace.shaded.fasterxml.jackson.core.PrettyPrinter;
import org.apache.htrace.shaded.fasterxml.jackson.core.SerializableString;
import org.apache.htrace.shaded.fasterxml.jackson.core.TreeNode;
import org.apache.htrace.shaded.fasterxml.jackson.core.Version;
import org.apache.htrace.shaded.fasterxml.jackson.core.Versioned;
import org.apache.htrace.shaded.fasterxml.jackson.core.io.CharacterEscapes;

abstract public class JsonGenerator implements Closeable, Flushable, Versioned
{
    protected JsonGenerator(){}
    protected PrettyPrinter _cfgPrettyPrinter = null;
    protected final void _throwInternal(){}
    protected void _reportError(String p0){}
    protected void _reportUnsupportedOperation(){}
    protected void _writeSimpleObject(Object p0){}
    public CharacterEscapes getCharacterEscapes(){ return null; }
    public FormatSchema getSchema(){ return null; }
    public JsonGenerator setCharacterEscapes(CharacterEscapes p0){ return null; }
    public JsonGenerator setHighestNonEscapedChar(int p0){ return null; }
    public JsonGenerator setPrettyPrinter(PrettyPrinter p0){ return null; }
    public JsonGenerator setRootValueSeparator(SerializableString p0){ return null; }
    public Object getOutputTarget(){ return null; }
    public PrettyPrinter getPrettyPrinter(){ return null; }
    public abstract JsonGenerator disable(JsonGenerator.Feature p0);
    public abstract JsonGenerator enable(JsonGenerator.Feature p0);
    public abstract JsonGenerator setCodec(ObjectCodec p0);
    public abstract JsonGenerator setFeatureMask(int p0);
    public abstract JsonGenerator useDefaultPrettyPrinter();
    public abstract JsonStreamContext getOutputContext();
    public abstract ObjectCodec getCodec();
    public abstract Version version();
    public abstract boolean isClosed();
    public abstract boolean isEnabled(JsonGenerator.Feature p0);
    public abstract int getFeatureMask();
    public abstract int writeBinary(Base64Variant p0, InputStream p1, int p2);
    public abstract void close();
    public abstract void flush();
    public abstract void writeBinary(Base64Variant p0, byte[] p1, int p2, int p3);
    public abstract void writeBoolean(boolean p0);
    public abstract void writeEndArray();
    public abstract void writeEndObject();
    public abstract void writeFieldName(SerializableString p0);
    public abstract void writeFieldName(String p0);
    public abstract void writeNull();
    public abstract void writeNumber(BigDecimal p0);
    public abstract void writeNumber(BigInteger p0);
    public abstract void writeNumber(String p0);
    public abstract void writeNumber(double p0);
    public abstract void writeNumber(float p0);
    public abstract void writeNumber(int p0);
    public abstract void writeNumber(long p0);
    public abstract void writeObject(Object p0);
    public abstract void writeRaw(String p0);
    public abstract void writeRaw(String p0, int p1, int p2);
    public abstract void writeRaw(char p0);
    public abstract void writeRaw(char[] p0, int p1, int p2);
    public abstract void writeRawUTF8String(byte[] p0, int p1, int p2);
    public abstract void writeRawValue(String p0);
    public abstract void writeRawValue(String p0, int p1, int p2);
    public abstract void writeRawValue(char[] p0, int p1, int p2);
    public abstract void writeStartArray();
    public abstract void writeStartObject();
    public abstract void writeString(SerializableString p0);
    public abstract void writeString(String p0);
    public abstract void writeString(char[] p0, int p1, int p2);
    public abstract void writeTree(TreeNode p0);
    public abstract void writeUTF8String(byte[] p0, int p1, int p2);
    public boolean canOmitFields(){ return false; }
    public boolean canUseSchema(FormatSchema p0){ return false; }
    public boolean canWriteBinaryNatively(){ return false; }
    public boolean canWriteObjectId(){ return false; }
    public boolean canWriteTypeId(){ return false; }
    public final JsonGenerator configure(JsonGenerator.Feature p0, boolean p1){ return null; }
    public final void writeArrayFieldStart(String p0){}
    public final void writeBinaryField(String p0, byte[] p1){}
    public final void writeBooleanField(String p0, boolean p1){}
    public final void writeNullField(String p0){}
    public final void writeNumberField(String p0, BigDecimal p1){}
    public final void writeNumberField(String p0, double p1){}
    public final void writeNumberField(String p0, float p1){}
    public final void writeNumberField(String p0, int p1){}
    public final void writeNumberField(String p0, long p1){}
    public final void writeObjectField(String p0, Object p1){}
    public final void writeObjectFieldStart(String p0){}
    public int getHighestEscapedChar(){ return 0; }
    public int writeBinary(InputStream p0, int p1){ return 0; }
    public void copyCurrentEvent(JsonParser p0){}
    public void copyCurrentStructure(JsonParser p0){}
    public void setSchema(FormatSchema p0){}
    public void writeBinary(byte[] p0){}
    public void writeBinary(byte[] p0, int p1, int p2){}
    public void writeNumber(short p0){}
    public void writeObjectId(Object p0){}
    public void writeObjectRef(Object p0){}
    public void writeOmittedField(String p0){}
    public void writeRaw(SerializableString p0){}
    public void writeStartArray(int p0){}
    public void writeStringField(String p0, String p1){}
    public void writeTypeId(Object p0){}
    static public enum Feature
    {
        AUTO_CLOSE_JSON_CONTENT, AUTO_CLOSE_TARGET, ESCAPE_NON_ASCII, FLUSH_PASSED_TO_STREAM, QUOTE_FIELD_NAMES, QUOTE_NON_NUMERIC_NUMBERS, STRICT_DUPLICATE_DETECTION, WRITE_BIGDECIMAL_AS_PLAIN, WRITE_NUMBERS_AS_STRINGS;
        private Feature() {}
        public boolean enabledByDefault(){ return false; }
        public boolean enabledIn(int p0){ return false; }
        public int getMask(){ return 0; }
        public static int collectDefaults(){ return 0; }
    }
}
