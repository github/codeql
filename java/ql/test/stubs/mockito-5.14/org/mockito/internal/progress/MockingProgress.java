/*
 * Copyright (c) 2007 Mockito contributors
 * This program is made available under the terms of the MIT License.
 */
package org.mockito.internal.progress;

import org.mockito.stubbing.OngoingStubbing;

public interface MockingProgress {
  OngoingStubbing<?> pullOngoingStubbing();
}