package org.mockito.internal;

import org.mockito.MockSettings;
import org.mockito.internal.creation.MockSettingsImpl;
import org.mockito.internal.progress.MockingProgress;
import org.mockito.stubbing.OngoingStubbing;
import org.mockito.mock.MockCreationSettings;
import static org.mockito.internal.util.MockUtil.createMock;

public class MockitoCore {
  public <T> T mock(Class<T> typeToMock, MockSettings settings) {
    MockSettingsImpl impl = (MockSettingsImpl) settings;
    MockCreationSettings<T> creationSettings = impl.build(typeToMock);
    T mock = createMock(creationSettings);
    return mock;
  }

  public <T> OngoingStubbing<T> when(T methodCall) {
    MockingProgress mockingProgress = new MockingProgress() {
      @Override
      public OngoingStubbing<?> pullOngoingStubbing() {
        return null;
      }
    };
    OngoingStubbing<T> stubbing = (OngoingStubbing<T>) mockingProgress.pullOngoingStubbing();
    return stubbing;
  }
}