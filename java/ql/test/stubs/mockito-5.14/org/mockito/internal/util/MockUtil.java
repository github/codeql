package org.mockito.internal.util;

import org.mockito.mock.MockCreationSettings;
import org.mockito.plugins.MockMaker;
import org.mockito.invocation.MockHandler;
import static org.mockito.internal.handler.MockHandlerFactory.createMockHandler;

public class MockUtil {
    public static <T> T createMock(MockCreationSettings<T> settings) {
        MockMaker mockMaker = getMockMaker(settings.getMockMaker());
        MockHandler mockHandler = createMockHandler(settings);
        return mockMaker.createMock(settings, mockHandler);
    }

    public static MockMaker getMockMaker(String mockMaker) {
        return null;
    }
}