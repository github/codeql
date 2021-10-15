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
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;

public abstract class BaseEncoding {
  public static final class DecodingException extends IOException {
  }
  public String encode(byte[] bytes) {
    return null;
  }

  public final String encode(byte[] bytes, int off, int len) {
    return null;
  }

  public abstract OutputStream encodingStream(Writer writer);

  public final ByteSink encodingSink(final CharSink encodedSink) {
    return null;
  }

  public abstract boolean canDecode(CharSequence chars);

  public final byte[] decode(CharSequence chars) {
    return null;
  }

  public abstract InputStream decodingStream(Reader reader);

  public final ByteSource decodingSource(final CharSource encodedSource) {
    return null;
  }

  public abstract BaseEncoding omitPadding();

  public abstract BaseEncoding withPadChar(char padChar);

  public abstract BaseEncoding withSeparator(String separator, int n);

  public abstract BaseEncoding upperCase();

  public abstract BaseEncoding lowerCase();

  public static BaseEncoding base64() {
    return null;
  }

  public static BaseEncoding base64Url() {
    return null;
  }

  public static BaseEncoding base32() {
    return null;
  }

  public static BaseEncoding base32Hex() {
    return null;
  }

  public static BaseEncoding base16() {
    return null;
  }

}
