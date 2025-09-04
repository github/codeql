/*
 * Copyright (c) 2007 Mockito contributors
 * This program is made available under the terms of the MIT License.
 */
package org.mockito.stubbing;

public interface OngoingStubbing<T> {
  OngoingStubbing<T> thenReturn(T value);
}