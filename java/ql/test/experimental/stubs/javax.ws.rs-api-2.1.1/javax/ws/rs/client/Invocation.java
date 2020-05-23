/*
 * Copyright (c) 2011, 2017 Oracle and/or its affiliates. All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0, which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * This Source Code may also be made available under the following Secondary
 * Licenses when the conditions for such availability set forth in the
 * Eclipse Public License v. 2.0 are satisfied: GNU General Public License,
 * version 2 with the GNU Classpath Exception, which is available at
 * https://www.gnu.org/software/classpath/license.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0
 */

package javax.ws.rs.client;

import java.util.Locale;
import java.util.concurrent.Future;

import javax.ws.rs.core.CacheControl;
import javax.ws.rs.core.Cookie;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

public interface Invocation {
    public static interface Builder extends SyncInvoker {
        public Invocation build(String method);
        public Invocation build(String method, Entity<?> entity);
        public Invocation buildGet();
        public Invocation buildDelete();
        public Invocation buildPost(Entity<?> entity);
        public Invocation buildPut(Entity<?> entity);
        public AsyncInvoker async();
        public Builder accept(String... mediaTypes);
        public Builder accept(MediaType... mediaTypes);
        public Builder acceptLanguage(Locale... locales);
        public Builder acceptLanguage(String... locales);
        public Builder acceptEncoding(String... encodings);
        public Builder cookie(Cookie cookie);
        public Builder cookie(String name, String value);
        public Builder cacheControl(CacheControl cacheControl);
        public Builder header(String name, Object value);
        public Builder headers(MultivaluedMap<String, Object> headers);
        public Builder property(String name, Object value);
        public CompletionStageRxInvoker rx();
        public <T extends RxInvoker> T rx(Class<T> clazz);
    }
    public Invocation property(String name, Object value);
    public Response invoke();
    public <T> T invoke(Class<T> responseType);
    public <T> T invoke(GenericType<T> responseType);
    public Future<Response> submit();
    public <T> Future<T> submit(Class<T> responseType);
    public <T> Future<T> submit(GenericType<T> responseType);
    public <T> Future<T> submit(InvocationCallback<T> callback);
}
