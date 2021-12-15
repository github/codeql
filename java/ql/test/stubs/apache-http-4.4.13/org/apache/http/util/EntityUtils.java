/*
 * ====================================================================
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */

package org.apache.http.util;

import java.io.IOException;
import java.nio.charset.Charset;
import org.apache.http.*;


public final class EntityUtils {
    public static void consumeQuietly(final HttpEntity entity) {
    }

    public static void consume(final HttpEntity entity) throws IOException {
    }

    public static void updateEntity(
            final HttpResponse response, final HttpEntity entity) throws IOException {
    }

    public static byte[] toByteArray(final HttpEntity entity) throws IOException {
      return null;
    }

    public static String getContentCharSet(final HttpEntity entity) {
      return null;
    }

    public static String getContentMimeType(final HttpEntity entity) {
      return null;
    }

    public static String toString(
            final HttpEntity entity, final Charset defaultCharset) throws IOException {
      return null;
    }

    public static String toString(
            final HttpEntity entity, final String defaultCharset) throws IOException {
      return null;
    }

    public static String toString(final HttpEntity entity) throws IOException, ParseException {
      return null;
    }

}
