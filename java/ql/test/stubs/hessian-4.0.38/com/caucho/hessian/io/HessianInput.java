package com.caucho.hessian.io;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

public class HessianInput extends AbstractHessianInput {

    public HessianInput() {
    }

    public HessianInput(InputStream is) { }

    public void init(InputStream is) { }

    public String getMethod() {
        return null;
    }

    public Throwable getReplyFault() {
        return null;
    }

    public int readCall() throws IOException {
        return 0;
    }

    public void skipOptionalCall() throws IOException { }

    public String readMethod() throws IOException {
        return null;
    }

    public void startCall() throws IOException { }

    public void completeCall() throws IOException { }

    public Object readReply(Class expectedClass) throws Throwable {
        return null;
    }

    public void startReply() throws Throwable { }

    public void startReplyBody() throws Throwable { }

    private Throwable prepareFault() throws IOException {
        return null;
    }

    public void completeReply() throws IOException { }

    public void completeValueReply() throws IOException { }

    public String readHeader() throws IOException {
        return null;
    }

    public void readNull() throws IOException { }

    public boolean readBoolean() throws IOException {
        return true;
    }

    public short readShort() throws IOException {
        return 11111;
    }

    public int readInt() throws IOException {
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

    private int parseChar() throws IOException {
        return 1;
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

    final int read() throws IOException {
        return 1;
    }

    public void close() { }

    public Reader getReader() {
        return null;
    }

    protected IOException expect(String expect, int ch) {
        return null;
    }

    protected String codeName(int ch) {
        return null;
    }

    protected IOException error(String message) {
        return null;
    }
}

