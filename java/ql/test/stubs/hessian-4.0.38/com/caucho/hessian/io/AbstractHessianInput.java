package com.caucho.hessian.io;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;

public abstract class AbstractHessianInput {

    public AbstractHessianInput() {
    }

    public void init(InputStream is) {
    }

    public abstract String getMethod();

    public void setRemoteResolver(HessianRemoteResolver resolver) { }

    public HessianRemoteResolver getRemoteResolver() {
        return null;
    }

    public void setSerializerFactory(SerializerFactory ser) {
    }

    public abstract int readCall() throws IOException;

    public void skipOptionalCall() throws IOException {
    }

    public abstract String readHeader() throws IOException;

    public abstract String readMethod() throws IOException;

    public int readMethodArgLength() throws IOException {
        return -1;
    }

    public abstract void startCall() throws IOException;

    public abstract void completeCall() throws IOException;

    public abstract Object readReply(Class var1) throws Throwable;

    public abstract void startReply() throws Throwable;

    public void startReplyBody() throws Throwable {
    }

    public abstract void completeReply() throws IOException;

    public abstract boolean readBoolean() throws IOException;

    public abstract void readNull() throws IOException;

    public abstract int readInt() throws IOException;

    public abstract long readLong() throws IOException;

    public abstract double readDouble() throws IOException;

    public abstract long readUTCDate() throws IOException;

    public abstract String readString() throws IOException;

    public abstract Reader getReader() throws IOException;

    public abstract InputStream readInputStream() throws IOException;

    public boolean readToOutputStream(OutputStream os) throws IOException {
        return true;
    }

    public abstract byte[] readBytes() throws IOException;

    public abstract Object readObject(Class var1) throws IOException;

    public abstract Object readObject() throws IOException;

    public abstract Object readRemote() throws IOException;

    public abstract Object readRef() throws IOException;

    public abstract int addRef(Object var1) throws IOException;

    public abstract void setRef(int var1, Object var2) throws IOException;

    public void resetReferences() {
    }

    public abstract int readListStart() throws IOException;

    public abstract int readLength() throws IOException;

    public abstract int readMapStart() throws IOException;

    public abstract String readType() throws IOException;

    public abstract boolean isEnd() throws IOException;

    public abstract void readEnd() throws IOException;

    public abstract void readMapEnd() throws IOException;

    public abstract void readListEnd() throws IOException;

    public void close() throws IOException {
    }
}

