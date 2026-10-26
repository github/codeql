package org.mockito.stubbing;

public interface Stubber {
  <T> T when(T mock);
}