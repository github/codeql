/*
 * Copyright 2013 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ratpack.core.http;

import io.netty.buffer.ByteBuf;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.Charset;

/**
 * Data that potentially has a content type.
 */
public interface TypedData {

  /**
   * The type of the data.
   *
   * @return The type of the data.
   */
  MediaType getContentType();

  /**
   * The data as text.
   * <p>
   * If a content type was provided, and it provided a charset parameter, that charset will be used to decode the text.
   * If no charset was provided, {@code UTF-8} will be assumed.
   * <p>
   * This can lead to incorrect results for non {@code text/*} type content types.
   * For example, {@code application/json} is implicitly {@code UTF-8} but this method will not know that.
   *
   * @return The data decoded as text
   */
  String getText();

  String getText(Charset charset);

  /**
   * The raw data as bytes.
   *
   * The returned array should not be modified.
   *
   * @return the raw data as bytes.
   */
  byte[] getBytes();

  /**
   * The raw data as a (unmodifiable) buffer.
   *
   * @return the raw data as bytes.
   */
  ByteBuf getBuffer();

  /**
   * Writes the data to the given output stream.
   * <p>
   * Data is effectively piped from {@link #getInputStream()} to the given output stream.
   * As such, if the given output stream might block (e.g. is backed by a file or socket) then
   * this should be called from a blocking thread using {@link Blocking#get(Factory)}
   * This method does not flush or close the stream.
   *
   * @param outputStream The stream to write to
   * @throws IOException any thrown when writing to the output stream
   */
  void writeTo(OutputStream outputStream) throws IOException;

  /**
   * An input stream of the data.
   * <p>
   * This input stream is backed by an in memory buffer.
   * Reading from this input stream will never block.
   * <p>
   * It is not necessary to close the input stream.
   *
   * @return an input stream of the data
   */
  InputStream getInputStream();

}
