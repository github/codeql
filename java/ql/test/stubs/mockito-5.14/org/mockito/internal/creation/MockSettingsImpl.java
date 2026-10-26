package org.mockito.internal.creation;

import org.mockito.MockSettings;
import org.mockito.mock.MockCreationSettings;

public class MockSettingsImpl<T> implements MockSettings {
  public <T2> MockCreationSettings<T2> build(Class<T2> typeToMock) {
    return new MockCreationSettings<T2>() {
      public String getMockMaker() {
        return null;
      }
    };
  }
}
