/*
 * Copyright (C) 2012 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.common.io;
import com.google.common.base.Optional;
import com.google.common.hash.HashCode;
import com.google.common.hash.HashFunction;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.Charset;
import java.util.Iterator;

public abstract class ByteSource {
  public CharSource asCharSource(Charset charset) {
    return null;
  }

  public abstract InputStream openStream() throws IOException;

  public InputStream openBufferedStream() throws IOException {
    return null;
  }

  public ByteSource slice(long offset, long length) {
    return null;
  }

  public boolean isEmpty() throws IOException {
    return false;
  }

  public Optional<Long> sizeIfKnown() {
    return null;
  }

  public long size() throws IOException {
    return 0;
  }

  public long copyTo(OutputStream output) throws IOException {
    return 0;
  }

  public long copyTo(ByteSink sink) throws IOException {
    return 0;
  }

  public byte[] read() throws IOException {
    return null;
  }

  public <T> T read(ByteProcessor<T> processor) throws IOException {
    return null;
  }

  public HashCode hash(HashFunction hashFunction) throws IOException {
    return null;
  }

  public boolean contentEquals(ByteSource other) throws IOException {
    return false;
  }

  public static ByteSource concat(Iterable<? extends ByteSource> sources) {
    return null;
  }

  public static ByteSource concat(Iterator<? extends ByteSource> sources) {
    return null;
  }

  public static ByteSource concat(ByteSource... sources) {
    return null;
  }

  public static ByteSource wrap(byte[] b) {
    return null;
  }

  public static ByteSource empty() {
    return null;
  }

}
