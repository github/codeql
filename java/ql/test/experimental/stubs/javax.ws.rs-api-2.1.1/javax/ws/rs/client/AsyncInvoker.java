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

import java.util.concurrent.Future;

import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.Response;

public interface AsyncInvoker {
    Future<Response> get();
    <T> Future<T> get(Class<T> responseType);
    <T> Future<T> get(GenericType<T> responseType);
    <T> Future<T> get(InvocationCallback<T> callback);
    Future<Response> put(Entity<?> entity);
    <T> Future<T> put(Entity<?> entity, Class<T> responseType);
    <T> Future<T> put(Entity<?> entity, GenericType<T> responseType);
    <T> Future<T> put(Entity<?> entity, InvocationCallback<T> callback);
    Future<Response> post(Entity<?> entity);
    <T> Future<T> post(Entity<?> entity, Class<T> responseType);
    <T> Future<T> post(Entity<?> entity, GenericType<T> responseType);
    <T> Future<T> post(Entity<?> entity, InvocationCallback<T> callback);
    Future<Response> delete();
    <T> Future<T> delete(Class<T> responseType);
    <T> Future<T> delete(GenericType<T> responseType);
    <T> Future<T> delete(InvocationCallback<T> callback);
    Future<Response> head();
    Future<Response> head(InvocationCallback<Response> callback);
    Future<Response> options();
    <T> Future<T> options(Class<T> responseType);
    <T> Future<T> options(GenericType<T> responseType);
    <T> Future<T> options(InvocationCallback<T> callback);
    Future<Response> trace();
    <T> Future<T> trace(Class<T> responseType);
    <T> Future<T> trace(GenericType<T> responseType);
    <T> Future<T> trace(InvocationCallback<T> callback);
    Future<Response> method(String name);
    <T> Future<T> method(String name, Class<T> responseType);
    <T> Future<T> method(String name, GenericType<T> responseType);
    <T> Future<T> method(String name, InvocationCallback<T> callback);
    Future<Response> method(String name, Entity<?> entity);
    <T> Future<T> method(String name, Entity<?> entity, Class<T> responseType);
    <T> Future<T> method(String name, Entity<?> entity, GenericType<T> responseType);
    <T> Future<T> method(String name, Entity<?> entity, InvocationCallback<T> callback);
}
