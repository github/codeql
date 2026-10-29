/*
 * Copyright (c) 2007 Mockito contributors
 * This program is made available under the terms of the MIT License.
 */
package org.mockito;

import org.mockito.ArgumentMatchers;
import org.mockito.MockSettings;
import org.mockito.internal.creation.MockSettingsImpl;
import org.mockito.stubbing.Answer;
import org.mockito.stubbing.OngoingStubbing;
import org.mockito.internal.MockitoCore;
import org.mockito.MockSettings;
import org.mockito.stubbing.Stubber;

public class Mockito extends ArgumentMatchers {
  static final MockitoCore MOCKITO_CORE = new MockitoCore();

  public static MockSettings withSettings() {
    return new MockSettings() {
    };
  }

  /**
   * Creates a mock object of the requested class or interface.
   * <p>
   * See examples in javadoc for the {@link Mockito} class.
   *
   * @param reified don't pass any values to it. It's a trick to detect the
   *                class/interface you
   *                want to mock.
   * @return the mock object.
   * @since 4.10.0
   */
  @SafeVarargs
  public static <T> T mock(T... reified) {
    return mock(withSettings(), reified);
  }

  /**
   * Creates a mock object of the requested class or interface with the given
   * default answer.
   * <p>
   * See examples in javadoc for the {@link Mockito} class.
   *
   * @param defaultAnswer the default answer to use.
   * @param reified       don't pass any values to it. It's a trick to detect the
   *                      class/interface you
   *                      want to mock.
   * @return the mock object.
   * @since 5.1.0
   */
  @SafeVarargs
  public static <T> T mock(@SuppressWarnings("rawtypes") Answer defaultAnswer, T... reified) {
    return mock(new Answer<T>() {
    }, reified);
  }

  /**
   * Creates a mock object of the requested class or interface with the given
   * name.
   * <p>
   * See examples in javadoc for the {@link Mockito} class.
   *
   * @param name    the mock name to use.
   * @param reified don't pass any values to it. It's a trick to detect the
   *                class/interface you
   *                want to mock.
   * @return the mock object.
   * @since 5.1.0
   */
  @SafeVarargs
  public static <T> T mock(String name, T... reified) {
    return mock(withSettings(), reified);
  }

  /**
   * Creates a mock object of the requested class or interface with the given
   * settings.
   * <p>
   * See examples in javadoc for the {@link Mockito} class.
   *
   * @param settings the mock settings to use.
   * @param reified  don't pass any values to it. It's a trick to detect the
   *                 class/interface you
   *                 want to mock.
   * @return the mock object.
   * @since 5.1.0
   */
  @SafeVarargs
  public static <T> T mock(MockSettings settings, T... reified) {
    if (reified == null || reified.length > 0) {
      throw new IllegalArgumentException(
          "Please don't pass any values here. Java will detect class automagically.");
    }

    return mock(getClassOf(reified), settings);
  }

  /**
   * Creates mock object of given class or interface.
   * <p>
   * See examples in javadoc for {@link Mockito} class
   *
   * @param classToMock class or interface to mock
   * @return mock object
   */
  public static <T> T mock(Class<T> classToMock) {
    return mock(classToMock, withSettings());
  }

  /**
   * Specifies mock name. Naming mocks can be helpful for debugging - the name is
   * used in all verification errors.
   * <p>
   * Beware that naming mocks is not a solution for complex code which uses too
   * many mocks or collaborators.
   * <b>If you have too many mocks then refactor the code</b> so that it's easy to
   * test/debug without necessity of naming mocks.
   * <p>
   * <b>If you use <code>&#064;Mock</code> annotation then you've got naming mocks
   * for free!</b> <code>&#064;Mock</code> uses field name as mock name.
   * {@link Mock Read more.}
   * <p>
   *
   * See examples in javadoc for {@link Mockito} class
   *
   * @param classToMock class or interface to mock
   * @param name        of the mock
   * @return mock object
   */
  public static <T> T mock(Class<T> classToMock, String name) {
    return mock(classToMock, new Answer<T>() {
    });
  }

  /**
   * Creates mock with a specified strategy for its answers to interactions.
   * It's quite an advanced feature and typically you don't need it to write
   * decent tests.
   * However it can be helpful when working with legacy systems.
   * <p>
   * It is the default answer so it will be used <b>only when you don't</b> stub
   * the method call.
   *
   * <pre class="code">
   * <code class="java">
   *   Foo mock = mock(Foo.class, RETURNS_SMART_NULLS);
   *   Foo mockTwo = mock(Foo.class, new YourOwnAnswer());
   * </code>
   * </pre>
   *
   * <p>
   * See examples in javadoc for {@link Mockito} class
   * </p>
   *
   * @param classToMock   class or interface to mock
   * @param defaultAnswer default answer for un-stubbed methods
   *
   * @return mock object
   */
  public static <T> T mock(Class<T> classToMock, Answer defaultAnswer) {
    return mock(classToMock, new Answer<T>() {
    });
  }

  /**
   * Creates a mock with some non-standard settings.
   * <p>
   * The number of configuration points for a mock will grow,
   * so we need a fluent way to introduce new configuration without adding more
   * and more overloaded Mockito.mock() methods.
   * Hence {@link MockSettings}.
   * 
   * <pre class="code">
   * <code class="java">
   *   Listener mock = mock(Listener.class, withSettings()
   *     .name("firstListner").defaultBehavior(RETURNS_SMART_NULLS));
   *   );
   * </code>
   * </pre>
   * 
   * <b>Use it carefully and occasionally</b>. What might be reason your test
   * needs non-standard mocks?
   * Is the code under test so complicated that it requires non-standard mocks?
   * Wouldn't you prefer to refactor the code under test, so that it is testable
   * in a simple way?
   * <p>
   * See also {@link Mockito#withSettings()}
   * <p>
   * See examples in javadoc for {@link Mockito} class
   *
   * @param classToMock  class or interface to mock
   * @param mockSettings additional mock settings
   * @return mock object
   */
  public static <T> T mock(Class<T> classToMock, MockSettings mockSettings) {
    return MOCKITO_CORE.mock(classToMock, mockSettings);
  }

  private static <T> Class<T> getClassOf(T[] array) {
    return (Class<T>) array.getClass().getComponentType();
  }

  public static <T> OngoingStubbing<T> when(T methodCall) {
    return MOCKITO_CORE.when(methodCall);
  }

  public static Stubber doReturn(Object toBeReturned) {
    return null;
  }

  public static Stubber doReturn(Object toBeReturned, Object... toBeReturnedNext) {
    return null;
  }
}
