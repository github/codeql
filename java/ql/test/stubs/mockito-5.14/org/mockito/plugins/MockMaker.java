package org.mockito.plugins;

import org.mockito.mock.MockCreationSettings;
import org.mockito.invocation.MockHandler;

public interface MockMaker {
  <T> T createMock(MockCreationSettings<T> settings, MockHandler handler);
}