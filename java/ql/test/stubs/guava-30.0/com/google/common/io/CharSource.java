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
import com.google.common.collect.ImmutableList;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.Iterator;
import java.util.function.Consumer;
import java.util.stream.Stream;
import org.checkerframework.checker.nullness.qual.Nullable;

public abstract class CharSource {
  public ByteSource asByteSource(Charset charset) {
    return null;
  }

  public abstract Reader openStream() throws IOException;

  public BufferedReader openBufferedStream() throws IOException {
    return null;
  }

  public Stream<String> lines() throws IOException {
    return null;
  }

  public Optional<Long> lengthIfKnown() {
    return null;
  }

  public long length() throws IOException {
    return 0;
  }

  public long copyTo(Appendable appendable) throws IOException {
    return 0;
  }

  public long copyTo(CharSink sink) throws IOException {
    return 0;
  }

  public String read() throws IOException {
    return null;
  }

  public @Nullable String readFirstLine() throws IOException {
    return null;
  }

  public ImmutableList<String> readLines() throws IOException {
    return null;
  }

  public <T> T readLines(LineProcessor<T> processor) throws IOException {
    return null;
  }

  public void forEachLine(Consumer<? super String> action) throws IOException {
  }

  public boolean isEmpty() throws IOException {
    return false;
  }

  public static CharSource concat(Iterable<? extends CharSource> sources) {
    return null;
  }

  public static CharSource concat(Iterator<? extends CharSource> sources) {
    return null;
  }

  public static CharSource concat(CharSource... sources) {
    return null;
  }

  public static CharSource wrap(CharSequence charSequence) {
    return null;
  }

  public static CharSource empty() {
    return null;
  }

}
