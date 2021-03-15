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

public interface Hasher extends PrimitiveSink {
  @Override
  Hasher putByte(byte b);

  @Override
  Hasher putBytes(byte[] bytes);

  @Override
  Hasher putBytes(byte[] bytes, int off, int len);

  @Override
  Hasher putBytes(ByteBuffer bytes);

  @Override
  Hasher putShort(short s);

  @Override
  Hasher putInt(int i);

  @Override
  Hasher putLong(long l);

  @Override
  Hasher putFloat(float f);

  @Override
  Hasher putDouble(double d);

  @Override
  Hasher putBoolean(boolean b);

  @Override
  Hasher putChar(char c);

  @Override
  Hasher putUnencodedChars(CharSequence charSequence);

  @Override
  Hasher putString(CharSequence charSequence, Charset charset);

  <T> Hasher putObject(T instance, Funnel<? super T> funnel);

  HashCode hash();

  @Override
  int hashCode();

}
