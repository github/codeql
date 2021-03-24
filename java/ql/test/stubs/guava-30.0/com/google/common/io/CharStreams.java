/*
 * Copyright (C) 2007 The Guava Authors
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
import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.util.List;

public final class CharStreams {
  public static long copy(Readable from, Appendable to) throws IOException {
    return 0;
  }

  public static String toString(Readable r) throws IOException {
    return null;
  }

  public static List<String> readLines(Readable r) throws IOException {
    return null;
  }

  public static <T> T readLines(Readable readable, LineProcessor<T> processor) throws IOException {
    return null;
  }

  public static long exhaust(Readable readable) throws IOException {
    return 0;
  }

  public static void skipFully(Reader reader, long n) throws IOException {
  }

  public static Writer nullWriter() {
    return null;
  }

  public static Writer asWriter(Appendable target) {
    return null;
  }

}
