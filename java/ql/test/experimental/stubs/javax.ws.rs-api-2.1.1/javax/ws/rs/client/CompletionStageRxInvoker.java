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

import java.util.concurrent.CompletionStage;

import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.Response;

public interface CompletionStageRxInvoker extends RxInvoker<CompletionStage> {

    @Override
    public CompletionStage<Response> get();

    @Override
    public <T> CompletionStage<T> get(Class<T> responseType);

    @Override
    public <T> CompletionStage<T> get(GenericType<T> responseType);

    @Override
    public CompletionStage<Response> put(Entity<?> entity);

    @Override
    public <T> CompletionStage<T> put(Entity<?> entity, Class<T> clazz);

    @Override
    public <T> CompletionStage<T> put(Entity<?> entity, GenericType<T> type);

    @Override
    public CompletionStage<Response> post(Entity<?> entity);

    @Override
    public <T> CompletionStage<T> post(Entity<?> entity, Class<T> clazz);

    @Override
    public <T> CompletionStage<T> post(Entity<?> entity, GenericType<T> type);

    @Override
    public CompletionStage<Response> delete();

    @Override
    public <T> CompletionStage<T> delete(Class<T> responseType);

    @Override
    public <T> CompletionStage<T> delete(GenericType<T> responseType);

    @Override
    public CompletionStage<Response> head();

    @Override
    public CompletionStage<Response> options();

    @Override
    public <T> CompletionStage<T> options(Class<T> responseType);

    @Override
    public <T> CompletionStage<T> options(GenericType<T> responseType);

    @Override
    public CompletionStage<Response> trace();

    @Override
    public <T> CompletionStage<T> trace(Class<T> responseType);

    @Override
    public <T> CompletionStage<T> trace(GenericType<T> responseType);

    @Override
    public CompletionStage<Response> method(String name);

    @Override
    public <T> CompletionStage<T> method(String name, Class<T> responseType);

    @Override
    public <T> CompletionStage<T> method(String name, GenericType<T> responseType);

    @Override
    public CompletionStage<Response> method(String name, Entity<?> entity);

    @Override
    public <T> CompletionStage<T> method(String name, Entity<?> entity, Class<T> responseType);

    @Override
    public <T> CompletionStage<T> method(String name, Entity<?> entity, GenericType<T> responseType);
}

