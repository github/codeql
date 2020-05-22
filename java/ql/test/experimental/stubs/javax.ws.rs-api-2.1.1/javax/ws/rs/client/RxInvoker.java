/*
 * Copyright (c) 2015, 2017 Oracle and/or its affiliates. All rights reserved.
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

import javax.ws.rs.core.GenericType;

public interface RxInvoker<T> {
    public T get();
    public <R> T get(Class<R> responseType);
    public <R> T get(GenericType<R> responseType);
    public T put(Entity<?> entity);
    public <R> T put(Entity<?> entity, Class<R> responseType);
    public <R> T put(Entity<?> entity, GenericType<R> responseType);
    public T post(Entity<?> entity);
    public <R> T post(Entity<?> entity, Class<R> responseType);
    public <R> T post(Entity<?> entity, GenericType<R> responseType);
    public T delete();
    public <R> T delete(Class<R> responseType);
    public <R> T delete(GenericType<R> responseType);
    public T head();
    public T options();
    public <R> T options(Class<R> responseType);
    public <R> T options(GenericType<R> responseType);
    public T trace();
    public <R> T trace(Class<R> responseType);
    public <R> T trace(GenericType<R> responseType);
    public T method(String name);
    public <R> T method(String name, Class<R> responseType);
    public <R> T method(String name, GenericType<R> responseType);
    public T method(String name, Entity<?> entity);
    public <R> T method(String name, Entity<?> entity, Class<R> responseType);
    public <R> T method(String name, Entity<?> entity, GenericType<R> responseType);
}

