/*
 * Copyright (c) 2007 Mockito contributors
 * This program is made available under the terms of the MIT License.
 */
package org.mockito.internal.handler;

import org.mockito.mock.MockCreationSettings;
import org.mockito.invocation.MockHandler;

public final class MockHandlerFactory {
    public static <T> MockHandler<T> createMockHandler(MockCreationSettings<T> settings) {
        return new MockHandlerImpl<T>();
    }
}