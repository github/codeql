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

package org.apache.http.entity;

import java.io.IOException;
import org.apache.http.HttpEntity;
import org.apache.http.Header;

public abstract class AbstractHttpEntity implements HttpEntity {
    @Override
    public Header getContentType() {
      return null;
    }

    @Override
    public Header getContentEncoding() {
      return null;
    }

    @Override
    public boolean isChunked() {
      return false;
    }

    public void setContentType(final Header contentType) {
    }

    public void setContentType(final String ctString) {
    }

    public void setContentEncoding(final Header contentEncoding) {
    }

    public void setContentEncoding(final String ceString) {
    }

    public void setChunked(final boolean b) {
    }

    @Override
    public void consumeContent() throws IOException {
    }

    @Override
    public String toString() {
      return null;
    }

}
