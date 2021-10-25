/*
 * Copyright (C) 2011 The Guava Authors
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

package com.google.common.hash;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;

public interface PrimitiveSink {
  PrimitiveSink putByte(byte b);

  PrimitiveSink putBytes(byte[] bytes);

  PrimitiveSink putBytes(byte[] bytes, int off, int len);

  PrimitiveSink putBytes(ByteBuffer bytes);

  PrimitiveSink putShort(short s);

  PrimitiveSink putInt(int i);

  PrimitiveSink putLong(long l);

  PrimitiveSink putFloat(float f);

  PrimitiveSink putDouble(double d);

  PrimitiveSink putBoolean(boolean b);

  PrimitiveSink putChar(char c);

  PrimitiveSink putUnencodedChars(CharSequence charSequence);

  PrimitiveSink putString(CharSequence charSequence, Charset charset);

}
