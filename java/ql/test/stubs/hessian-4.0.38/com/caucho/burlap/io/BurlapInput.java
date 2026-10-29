package com.caucho.burlap.io;

import com.caucho.hessian.io.SerializerFactory;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.TimeZone;
import org.w3c.dom.Node;

public class BurlapInput extends AbstractBurlapInput {

    public BurlapInput() { }

    public BurlapInput(InputStream is) { }

    public void setSerializerFactory(SerializerFactory factory) { }

    public SerializerFactory getSerializerFactory() {
        return null;
    }

    public void init(InputStream is) { }

    public String getMethod() {
        return null;
    }

    public Throwable getReplyFault() {
        return null;
    }

    public void startCall() throws IOException { }

    public int readCall() throws IOException {
        return 1;
    }

    public String readMethod() throws IOException {
        return null;
    }

    public void completeCall() throws IOException { }

    public Object readReply(Class expectedClass) throws Throwable {
        return null;
    }

    public void startReply() throws Throwable { }

    private Throwable prepareFault() throws IOException {
        return null;
    }

    public void completeReply() throws IOException { }

    public String readHeader() throws IOException {
        return null;
    }

    public void readNull() throws IOException { }

    public boolean readBoolean() throws IOException {
        return true;
    }

    public byte readByte() throws IOException {
        return 1;
    }

    public short readShort() throws IOException {
        return 1;
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

    public long readLocalDate() throws IOException {
        return 1L;
    }

    public String readString() throws IOException {
        return null;
    }

    public Node readNode() throws IOException {
        return null;
    }

    public byte[] readBytes() throws IOException {
        return null;
    }

    public int readLength() throws IOException {
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

    public Object resolveRemote(String type, String url) throws IOException {
        return null;
    }

    public String readType() throws IOException {
        return null;
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

    protected long parseDate() throws IOException {
        return 1L;
    }

    protected long parseDate(Calendar calendar) throws IOException {
        return 1L;
    }

    protected String parseString() throws IOException {
        return null;
    }

    protected StringBuffer parseString(StringBuffer sbuf) throws IOException {
        return null;
    }

    Node parseXML() throws IOException {
        return null;
    }

    int readChar() throws IOException {
        return 1;
    }

    protected byte[] parseBytes() throws IOException {
        return null;
    }

    protected ByteArrayOutputStream parseBytes(ByteArrayOutputStream bos) throws IOException {
        return null;
    }

    public void expectTag(int expectTag) throws IOException { }

    protected int parseTag() throws IOException {
        return 1;
    }

    private boolean isTagChar(int ch) {
        return true;
    }

    protected int skipWhitespace() throws IOException {
        return 1;
    }

    protected boolean isWhitespace(int ch) throws IOException {
        return true;
    }

    int read(byte[] buffer, int offset, int length) throws IOException {
        return 1;
    }

    int read() throws IOException {
        return 1;
    }

    public Reader getReader() {
        return null;
    }

    public InputStream readInputStream() {
        return null;
    }

    public InputStream getInputStream() {
        return null;
    }

    protected IOException expectBeginTag(String expect, String tag) {
        return null;
    }

    protected IOException expectedChar(String expect, int ch) {
        return null;
    }

    protected IOException expectedTag(String expect, int tag) {
        return null;
    }

    protected IOException error(String message) {
        return null;
    }

    protected static String tagName(int tag) {
        return null;
    }
}

