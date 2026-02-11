package com.example;
import java.io.*;

public final class MyObjectInput implements ObjectInput {

  @Override
  public Object readObject() throws ClassNotFoundException, IOException {
    return null;
  }

  @Override
  public int read() throws IOException {
    return 0;
  }

  @Override
  public int read(byte[] b) throws IOException {
    return 0;
  }

  @Override
  public int read(byte[] b, int off, int len) throws IOException {
    return 0;
  }

  @Override
  public long skip(long n) throws IOException {
    return 0;
  }

  @Override
  public int available() throws IOException {
    return 0;
  }

  @Override
  public void close() throws IOException {}

  @Override
  public void readFully(byte[] b) throws IOException {}

  @Override
  public void readFully(byte[] b, int off, int len) throws IOException {}

  @Override
  public int skipBytes(int n) throws IOException {
    return 0;
  }

  @Override
  public boolean readBoolean() throws IOException {
    return false;
  }

  @Override
  public byte readByte() throws IOException {
    return 0;
  }

  @Override
  public int readUnsignedByte() throws IOException {
    return 0;
  }

  @Override
  public short readShort() throws IOException {
    return 0;
  }

  @Override
  public int readUnsignedShort() throws IOException {
    return 0;
  }

  @Override
  public char readChar() throws IOException {
    return 0;
  }

  @Override
  public int readInt() throws IOException {
    return 0;
  }

  @Override
  public long readLong() throws IOException {
    return 0;
  }

  @Override
  public float readFloat() throws IOException {
    return 0;
  }

  @Override
  public double readDouble() throws IOException {
    return 0;
  }

  @Override
  public String readLine() throws IOException {
    return null;
  }

  @Override
  public String readUTF() throws IOException {
    return null;
  }
}
