package com.google.common.io;

import com.google.common.collect.ImmutableList;
import java.io.InputStreamReader;
import java.io.Reader;
import java.lang.StringBuffer;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.Closeable;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;

class TestIO {
    Object taint() { return null; }
    String staint(){ return (String) taint(); }
    byte[] btaint() { return (byte[]) taint(); }
    InputStream itaint() { return (InputStream) taint(); }
    ReadableByteChannel rbctaint() { return (ReadableByteChannel) taint(); }
    Reader rtaint() { return new InputStreamReader(itaint()); }
    Path ptaint() { return (Path) taint(); }

    void sink(Object o) {}

    void test1() {
        BaseEncoding enc = BaseEncoding.base64();
        sink(enc.decode(staint())); // $numTaintFlow=1
        sink(enc.encode(btaint())); // $numTaintFlow=1
        sink(enc.encode(btaint(), 0, 42)); // $numTaintFlow=1
        sink(enc.decodingStream(rtaint())); // $numTaintFlow=1
        sink(enc.decodingSource(CharSource.wrap(staint()))); // $numTaintFlow=1
        sink(enc.withSeparator(staint(), 10).omitPadding().lowerCase().decode("abc")); // $numTaintFlow=1
    }

    void test2() throws IOException {
        ByteSource b = ByteSource.wrap(btaint());
        sink(b.openStream()); // $numTaintFlow=1
        sink(b.openBufferedStream()); // $numTaintFlow=1
        sink(b.asCharSource(null)); // $numTaintFlow=1
        sink(b.slice(42,1337)); // $numTaintFlow=1
        sink(b.read()); // $numTaintFlow=1
        sink(ByteSource.concat(ByteSource.empty(), ByteSource.empty(), b)); // $numTaintFlow=1
        sink(ByteSource.concat(ImmutableList.of(ByteSource.empty(), ByteSource.empty(), b))); // $numTaintFlow=1
        sink(b.read(new MyByteProcessor())); // $ MISSING:numTaintFlow=1
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        b.copyTo(out);
        sink(out.toByteArray()); // $numTaintFlow=1

        CharSource c = CharSource.wrap(staint());
        sink(c.openStream()); // $numTaintFlow=1
        sink(c.openBufferedStream()); // $numTaintFlow=1
        sink(c.asByteSource(null)); // $numTaintFlow=1
        sink(c.readFirstLine()); // $numTaintFlow=1
        sink(c.readLines()); // $numTaintFlow=1
        sink(c.read()); // $numTaintFlow=1
        sink(c.lines()); // $numTaintFlow=1
        sink(CharSource.concat(CharSource.empty(), CharSource.empty(), c)); // $numTaintFlow=1
        sink(CharSource.concat(ImmutableList.of(CharSource.empty(), CharSource.empty(), c))); // $numTaintFlow=1
        sink(c.readLines(new MyLineProcessor())); // $ MISSING:numTaintFlow=1
        c.forEachLine(l -> sink(l)); // $ MISSING:numTaintFlow=1
        StringBuffer buf = new StringBuffer();
        c.copyTo(buf);
        sink(buf); // $numTaintFlow=1
    }

    class MyByteProcessor implements ByteProcessor<Object> {
        byte[] buf;
        public Object getResult() { return buf; }
        public boolean processBytes(byte[] b, int off, int len)  { this.buf = b; return false; }
    }

    class MyLineProcessor implements LineProcessor<String> {
        String s = "";
        public String getResult() { return s; }
        public boolean processLine(String l)  { this.s += l; return true; }
    }

    void test3() throws IOException {
        {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            ByteStreams.copy(itaint(), out);
            sink(out); // $numTaintFlow=1
        }
        {
            WritableByteChannel out = FileChannel.open(Paths.get("/tmp/xyz"));
            ByteStreams.copy(rbctaint(), out);
            sink(out); // $numTaintFlow=1
        }
        sink(ByteStreams.limit(itaint(), 1337)); // $numTaintFlow=1
        sink(ByteStreams.newDataInput(btaint())); // $numTaintFlow=1
        sink(ByteStreams.newDataInput(btaint(), 0)); // $numTaintFlow=1
        sink(ByteStreams.newDataInput(btaint())); // $numTaintFlow=1
        sink(ByteStreams.newDataInput(btaint()).readLine()); // $ MISSING:numTaintFlow=1
        sink(ByteStreams.newDataInput(new ByteArrayInputStream(btaint()))); // $numTaintFlow=1
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        out.write(btaint());
        sink(ByteStreams.newDataOutput(out)); // $numTaintFlow=1
        byte[] b1 = null, b2 = null, b3 = null;
        ByteStreams.read(itaint(), b1, 0, 42);
        sink(b1); // $numTaintFlow=1
        ByteStreams.readFully(itaint(), b2);
        sink(b2); // $numTaintFlow=1
        ByteStreams.readFully(itaint(), b3, 0, 42);
        sink(b3); // $numTaintFlow=1
        sink(ByteStreams.readBytes(itaint(), new MyByteProcessor())); // $ MISSING:numTaintFlow=1
        sink(ByteStreams.toByteArray(itaint())); // $numTaintFlow=1
        ByteArrayDataOutput out2 = ByteStreams.newDataOutput();
        out2.writeUTF(staint());
        sink(out2.toByteArray()); // $numTaintFlow=1

        StringBuffer buf = new StringBuffer();
        CharStreams.copy(rtaint(), buf);
        sink(buf); // $numTaintFlow=1
        sink(CharStreams.readLines(rtaint())); // $numTaintFlow=1
        sink(CharStreams.readLines(rtaint(), new MyLineProcessor())); // $ MISSING:numTaintFlow=1
        sink(CharStreams.toString(rtaint())); // $numTaintFlow=1
    }

    void test4() throws IOException {
        sink(Closer.create().register((Closeable) taint())); // $numValueFlow=1
        sink(new LineReader(rtaint()).readLine()); // $numTaintFlow=1
        sink(Files.simplifyPath(staint())); // $numTaintFlow=1
        sink(Files.getFileExtension(staint())); // $numTaintFlow=1
        sink(Files.getNameWithoutExtension(staint())); // $numTaintFlow=1
        sink(MoreFiles.getFileExtension(ptaint())); // $numTaintFlow=1
        sink(MoreFiles.getNameWithoutExtension(ptaint())); // $numTaintFlow=1
    }

    void test6() throws IOException {
        sink(new CountingInputStream(itaint())); // $numTaintFlow=1
        byte[] buf = null;
        new CountingInputStream(itaint()).read(buf, 0, 42); 
        sink(buf); // $numTaintFlow=1
        sink(new LittleEndianDataInputStream(itaint())); // $numTaintFlow=1
        sink(new LittleEndianDataInputStream(itaint()).readUTF()); // $ MISSING:numTaintFlow=1
    }
}