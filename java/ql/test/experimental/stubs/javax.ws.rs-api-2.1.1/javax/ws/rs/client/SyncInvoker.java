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

import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.Response;

public interface SyncInvoker {
    Response get();
    <T> T get(Class<T> responseType);
    <T> T get(GenericType<T> responseType);
    Response put(Entity<?> entity);
    <T> T put(Entity<?> entity, Class<T> responseType);
    <T> T put(Entity<?> entity, GenericType<T> responseType);
    Response post(Entity<?> entity);
    <T> T post(Entity<?> entity, Class<T> responseType);
    <T> T post(Entity<?> entity, GenericType<T> responseType);
    Response delete();
    <T> T delete(Class<T> responseType);
    <T> T delete(GenericType<T> responseType);
    Response head();
    Response options();
    <T> T options(Class<T> responseType);
    <T> T options(GenericType<T> responseType);
    Response trace();
    <T> T trace(Class<T> responseType);
    <T> T trace(GenericType<T> responseType);
    Response method(String name);
    <T> T method(String name, Class<T> responseType);
    <T> T method(String name, GenericType<T> responseType);
    Response method(String name, Entity<?> entity);
    <T> T method(String name, Entity<?> entity, Class<T> responseType);
    <T> T method(String name, Entity<?> entity, GenericType<T> responseType);
}
