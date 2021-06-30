package com.caucho.hessian.io;

import java.io.ByteArrayOutputStream;
import java.io.EOFException;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Hessian2Input extends AbstractHessianInput {

    public Hessian2Input() { }

    public Hessian2Input(InputStream is) { }

    public String getMethod() {
        return null;
    }

    public Throwable getReplyFault() {
        return null;
    }

    public int readCall() throws IOException {
        return 1;
    }

    public int readEnvelope() throws IOException {
        return 1;
    }

    public void completeEnvelope() throws IOException { }

    public String readMethod() throws IOException {
        return null;
    }

    public int readMethodArgLength() throws IOException {
        return 1;
    }

    public void startCall() throws IOException { }

    public Object[] readArguments() throws IOException {
        return null;
    }

    public void completeCall() throws IOException { }

    public Object readReply(Class expectedClass) throws Throwable {
        return null;
    }

    public void startReply() throws Throwable { }

    private Throwable prepareFault(HashMap fault) throws IOException {
        return null;
    }

    public void completeReply() throws IOException { }

    public void completeValueReply() throws IOException { }

    public String readHeader() throws IOException {
        return null;
    }

    public int startMessage() throws IOException {
        return 1;
    }

    public void completeMessage() throws IOException { }

    public void readNull() throws IOException { }

    public boolean readBoolean() throws IOException {
        return true;
    }

    public short readShort() throws IOException {
        return 11111;
    }

    public final int readInt() throws IOException {
        return 1;
    }

    public long readLong() throws IOException {
        return 1L;
    }

    public float readFloat() throws IOException {
        return 1.1F;
    }

    public double readDouble() throws IOException {
        return 1.1;
    }

    public long readUTCDate() throws IOException {
        return 1L;
    }

    public int readChar() throws IOException {
        return 1;
    }

    public int readString(char[] buffer, int offset, int length) throws IOException {
        return 1;
    }

    public String readString() throws IOException {
        return null;
    }

    public byte[] readBytes() throws IOException {
        return null;
    }

    public int readByte() throws IOException {
        return 1;
    }

    public int readBytes(byte[] buffer, int offset, int length) throws IOException {
        return 1;
    }

    private HashMap readFault() throws IOException {
        return null;
    }

    public Object readObject(Class cl) throws IOException {
        return null;
    }

    public Object readObject() throws IOException {
        return null;
    }

    private void readObjectDefinition(Class<?> cl) throws IOException { }

    private Object readObjectInstance(Class<?> cl, Hessian2Input.ObjectDefinition def) throws IOException {
        return null;
    }

    public Object readRemote() throws IOException {
        return null;
    }

    public Object readRef() throws IOException {
        return null;
    }

    public int readListStart() throws IOException {
        return 1;
    }

    public int readMapStart() throws IOException {
        return 1;
    }

    public boolean isEnd() throws IOException {
        return true;
    }

    public void readEnd() throws IOException { }

    public void readMapEnd() throws IOException { }

    public void readListEnd() throws IOException { }

    public int addRef(Object ref) {
        return 1;
    }

    public void setRef(int i, Object ref) { }

    public void resetReferences() { }

    public void reset() { }

    public void resetBuffer() { }

    public Object readStreamingObject() throws IOException {
        return null;
    }

    public Object resolveRemote(String type, String url) throws IOException {
        return null;
    }

    public String readType() throws IOException {
        return null;
    }

    public int readLength() throws IOException {
        return 1;
    }

    private int parseInt() throws IOException {
        return 1;
    }

    private long parseLong() throws IOException {
        return 1L;
    }

    private double parseDouble() throws IOException {
        return 1.1;
    }

    private void parseString(StringBuilder sbuf) throws IOException { }

    private int parseChar() throws IOException {
        return 1;
    }

    private boolean parseChunkLength() throws IOException {
        return true;
    }

    private int parseUTF8Char() throws IOException {
        return 1;
    }

    private int parseByte() throws IOException {
        return 1;
    }

    public InputStream readInputStream() throws IOException {
        return null;
    }

    int read(byte[] buffer, int offset, int length) throws IOException {
        return 1;
    }

    public final int read() throws IOException {
        return 1;
    }

    protected void unread() { }

    private final boolean readBuffer() throws IOException {
        return true;
    }

    public Reader getReader() {
        return null;
    }

    protected IOException expect(String expect, int ch) throws IOException {
        return null;
    }

    private String buildDebugContext(byte[] buffer, int offset, int length, int errorOffset) {
        return null;
    }

    private void addDebugChar(StringBuilder sb, int ch) { }

    protected String codeName(int ch) {
        return null;
    }

    protected IOException error(String message) {
        return null;
    }

    public void free() { }

    public void close() throws IOException { }

    static final class ObjectDefinition {
    }

    class ReadInputStream extends InputStream {

        ReadInputStream() { }

        public int read() throws IOException {
            return 1;
        }

        public int read(byte[] buffer, int offset, int length) throws IOException {
            return 1;
        }

        public void close() throws IOException { }
    }
}

