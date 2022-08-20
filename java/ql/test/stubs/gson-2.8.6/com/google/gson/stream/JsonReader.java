package com.google.gson.stream;

import java.io.Closeable;
import java.io.IOException;
import java.io.Reader;

public class JsonReader implements Closeable {
  public JsonReader(Reader in) {
  }

  public final void setLenient(boolean lenient) {
  }

  public final boolean isLenient() {
    return false;
  }

  public void beginArray() throws IOException {
  }

  public void endArray() throws IOException {
  }

  public void beginObject() throws IOException {
  }

  public void endObject() throws IOException {
  }

  public boolean hasNext() throws IOException {
      return false;
  }

  public String nextName() throws IOException {
    return null;
  }

  public String nextString() throws IOException {
    return null;
  }

  public boolean nextBoolean() throws IOException {
    return false;
  }

  public void nextNull() throws IOException {
  }

  public double nextDouble() throws IOException {
    return -1;
  }

  public long nextLong() throws IOException {
    return -1;
  }

  public int nextInt() throws IOException {
    return -1;
  }

  public void close() throws IOException {
  }

  public void skipValue() throws IOException {
  }
}