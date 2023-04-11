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

package org.apache.hc.core5.http;

/**
 * HTTP messages consist of requests from client to server and responses
 * from server to client.
 *
 * @since 4.0
 */
public interface HttpMessage extends MessageHeaders {
    void setVersion(ProtocolVersion version);

    ProtocolVersion getVersion();

    void addHeader(Header header);

    void addHeader(String name, Object value);

    void setHeader(Header header);

    void setHeader(String name, Object value);

    void setHeaders(Header... headers);

    boolean removeHeader(Header header);

    boolean removeHeaders(String name);

}
