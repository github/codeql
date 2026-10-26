package org.junit;

import org.junit.function.ThrowingRunnable;

//BSD License
//
//Copyright (c) 2000-2006, www.hamcrest.org
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//
//Redistributions of source code must retain the above copyright notice, this list of
//conditions and the following disclaimer. Redistributions in binary form must reproduce
//the above copyright notice, this list of conditions and the following disclaimer in
//the documentation and/or other materials provided with the distribution.
//
//Neither the name of Hamcrest nor the names of its contributors may be used to endorse
//or promote products derived from this software without specific prior written
//permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
//EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
//SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
//BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
//WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
//DAMAGE.

/*
 * MODIFIED version of JUnit 4.13 as available at
 *   https://search.maven.org/remotecontent?filepath=junit/junit/4.13/junit-4.13-sources.jar
 * Only parts of this file have been retained for test purposes.
 */

public class Assert {
  /**
   * Asserts that a condition is true. If it isn't it throws an
   * {@link AssertionError} with the given message.
   *
   * @param message   the identifying message for the {@link AssertionError}
   *                  (<code>null</code>
   *                  okay)
   * @param condition condition to be checked
   */
  static public void assertTrue(String message, boolean condition) {
    return;
  }

  /**
   * Asserts that a condition is true. If it isn't it throws an
   * {@link AssertionError} without a message.
   *
   * @param condition condition to be checked
   */
  static public void assertTrue(boolean condition) {
    return;
  }

  /**
   * Asserts that a condition is false. If it isn't it throws an
   * {@link AssertionError} with the given message.
   *
   * @param message   the identifying message for the {@link AssertionError}
   *                  (<code>null</code>
   *                  okay)
   * @param condition condition to be checked
   */
  static public void assertFalse(String message, boolean condition) {
    return;
  }

  /**
   * Asserts that a condition is false. If it isn't it throws an
   * {@link AssertionError} without a message.
   *
   * @param condition condition to be checked
   */
  static public void assertFalse(boolean condition) {
    return;
  }

  /**
   * Fails a test with the given message.
   *
   * @param message the identifying message for the {@link AssertionError}
   *                (<code>null</code>
   *                okay)
   * @see AssertionError
   */
  static public void fail(String message) {
    if (message == null) {
      throw new AssertionError();
    }
    throw new AssertionError(message);
  }

  /**
   * Asserts that an object isn't null. If it is an {@link AssertionError} is
   * thrown with the given message.
   *
   * @param message the identifying message for the {@link AssertionError}
   *                (<code>null</code>
   *                okay)
   * @param object  Object to check or <code>null</code>
   */
  static public void assertNotNull(String message, Object object) {
    return;
  }

  /**
   * Asserts that an object isn't null. If it is an {@link AssertionError} is
   * thrown.
   *
   * @param object Object to check or <code>null</code>
   */
  static public void assertNotNull(Object object) {
    return;
  }

  /**
   * Asserts that an object is null. If it is not, an {@link AssertionError}
   * is thrown with the given message.
   *
   * @param message the identifying message for the {@link AssertionError}
   *                (<code>null</code>
   *                okay)
   * @param object  Object to check or <code>null</code>
   */
  static public void assertNull(String message, Object object) {
    return;
  }

  /**
   * Asserts that an object is null. If it isn't an {@link AssertionError} is
   * thrown.
   *
   * @param object Object to check or <code>null</code>
   */
  static public void assertNull(Object object) {
    return;
  }

  private static boolean equalsRegardingNull(Object expected, Object actual) {
    if (expected == null) {
      return actual == null;
    }

    return isEquals(expected, actual);
  }

  private static boolean isEquals(Object expected, Object actual) {
    return expected.equals(actual);
  }

  /**
   * Asserts that two doubles are equal to within a positive delta.
   * If they are not, an {@link AssertionError} is thrown with the given
   * message. If the expected value is infinity then the delta value is
   * ignored. NaNs are considered equal:
   * <code>assertEquals(Double.NaN, Double.NaN, *)</code> passes
   *
   * @param message  the identifying message for the {@link AssertionError}
   *                 (<code>null</code>
   *                 okay)
   * @param expected expected value
   * @param actual   the value to check against <code>expected</code>
   * @param delta    the maximum delta between <code>expected</code> and
   *                 <code>actual</code> for which both numbers are still
   *                 considered equal.
   */
  public static void assertEquals(String message, double expected,
      double actual, double delta) {
    return;
  }

  private static void failNotEquals(String message, Object expected,
      Object actual) {
    fail(format(message, expected, actual));
  }

  static String format(String message, Object expected, Object actual) {
    String formatted = "";
    if (message != null && !"".equals(message)) {
      formatted = message + " ";
    }
    String expectedString = String.valueOf(expected);
    String actualString = String.valueOf(actual);
    if (equalsRegardingNull(expectedString, actualString)) {
      return formatted + "expected: "
          + formatClassAndValue(expected, expectedString)
          + " but was: " + formatClassAndValue(actual, actualString);
    } else {
      return formatted + "expected:<" + expectedString + "> but was:<"
          + actualString + ">";
    }
  }

  private static String formatClass(Class<?> value) {
      String className = value.getCanonicalName();
      return className == null ? value.getName() : className;
  }

  private static String formatClassAndValue(Object value, String valueString) {
    String className = value == null ? "null" : value.getClass().getName();
    return className + "<" + valueString + ">";
  }

  /**
   * Asserts that two floats are equal to within a positive delta.
   * If they are not, an {@link AssertionError} is thrown with the given
   * message. If the expected value is infinity then the delta value is
   * ignored. NaNs are considered equal:
   * <code>assertEquals(Float.NaN, Float.NaN, *)</code> passes
   *
   * @param message  the identifying message for the {@link AssertionError}
   *                 (<code>null</code>
   *                 okay)
   * @param expected expected value
   * @param actual   the value to check against <code>expected</code>
   * @param delta    the maximum delta between <code>expected</code> and
   *                 <code>actual</code> for which both numbers are still
   *                 considered equal.
   */
  public static void assertEquals(String message, float expected, float actual,
      float delta) {
    if (floatIsDifferent(expected, actual, delta)) {
      failNotEquals(message, Float.valueOf(expected), Float.valueOf(actual));
    }
  }

  private static boolean doubleIsDifferent(double d1, double d2, double delta) {
    if (Double.compare(d1, d2) == 0) {
      return false;
    }
    if ((Math.abs(d1 - d2) <= delta)) {
      return false;
    }

    return true;
  }

  private static boolean floatIsDifferent(float f1, float f2, float delta) {
    if (Float.compare(f1, f2) == 0) {
      return false;
    }
    if ((Math.abs(f1 - f2) <= delta)) {
      return false;
    }

    return true;
  }

  /**
   * Asserts that two longs are equal. If they are not, an
   * {@link AssertionError} is thrown.
   *
   * @param expected expected long value.
   * @param actual   actual long value
   */
  public static void assertEquals(long expected, long actual) {
    assertEquals(null, expected, actual);
  }

  /**
   * Asserts that two longs are equal. If they are not, an
   * {@link AssertionError} is thrown with the given message.
   *
   * @param message  the identifying message for the {@link AssertionError}
   *                 (<code>null</code>
   *                 okay)
   * @param expected long expected value.
   * @param actual   long actual value
   */
  public static void assertEquals(String message, long expected, long actual) {
    if (expected != actual) {
      failNotEquals(message, Long.valueOf(expected), Long.valueOf(actual));
    }
  }

  /**
   * @deprecated Use
   *             <code>assertEquals(double expected, double actual, double
   * delta)</code> instead
   */
  @Deprecated
  public static void assertEquals(double expected, double actual) {
    assertEquals(null, expected, actual);
  }

  /**
   * @deprecated Use
   *             <code>assertEquals(String message, double expected, double
   * actual, double delta)</code> instead
   */
  @Deprecated
  public static void assertEquals(String message, double expected,
      double actual) {
    fail("Use assertEquals(expected, actual, delta) to compare " +
        "floating-point numbers");
  }

  /**
   * Asserts that two doubles are equal to within a positive delta.
   * If they are not, an {@link AssertionError} is thrown. If the expected
   * value is infinity then the delta value is ignored.NaNs are considered
   * equal: <code>assertEquals(Double.NaN, Double.NaN, *)</code> passes
   *
   * @param expected expected value
   * @param actual   the value to check against <code>expected</code>
   * @param delta    the maximum delta between <code>expected</code> and
   *                 <code>actual</code> for which both numbers are still
   *                 considered equal.
   */
  public static void assertEquals(double expected, double actual,
      double delta) {
    assertEquals(null, expected, actual, delta);
  }

  /**
   * Asserts that two floats are equal to within a positive delta.
   * If they are not, an {@link AssertionError} is thrown. If the expected
   * value is infinity then the delta value is ignored. NaNs are considered
   * equal: <code>assertEquals(Float.NaN, Float.NaN, *)</code> passes
   *
   * @param expected expected value
   * @param actual   the value to check against <code>expected</code>
   * @param delta    the maximum delta between <code>expected</code> and
   *                 <code>actual</code> for which both numbers are still
   *                 considered equal.
   */
  public static void assertEquals(float expected, float actual, float delta) {
    assertEquals(null, expected, actual, delta);
  }

  /**
   * Asserts that two objects are equal. If they are not, an
   * {@link AssertionError} without a message is thrown. If
   * <code>expected</code> and <code>actual</code> are <code>null</code>,
   * they are considered equal.
   *
   * @param expected expected value
   * @param actual   the value to check against <code>expected</code>
   */
  public static void assertEquals(Object expected, Object actual) {
    assertEquals(null, expected, actual);
  }

  public static void assertEquals(String message, Object expected,
      Object actual) {
  }

  public static void assertNotEquals(String message, Object unexpected, Object actual) {
    return;
  }

  public static void assertNotEquals(Object unexpected, Object actual) {
    assertNotEquals(null, unexpected, actual);
  }

  public static void assertNotEquals(String message, long unexpected, long actual) {
    return;
  }

  public static void assertNotEquals(long unexpected, long actual) {
    assertNotEquals(null, unexpected, actual);
  }

  public static void assertNotEquals(String message, double unexpected, double actual, double delta) {
    return;
  }

  public static void assertNotEquals(double unexpected, double actual, double delta) {
    assertNotEquals(null, unexpected, actual, delta);
  }

  public static void assertNotEquals(String message, float unexpected, float actual, float delta) {
    return;
  }

  public static void assertNotEquals(float unexpected, float actual, float delta) {
    assertNotEquals(null, unexpected, actual, delta);
  }

  public static void assertNotSame(String message, Object unexpected, Object actual) {
    return;
  }

  public static void assertNotSame(Object unexpected, Object actual) {
    assertNotSame(null, unexpected, actual);
  }

  public static void assertSame(String message, Object expected, Object actual) {
    return;
  }

  public static void assertSame(Object expected, Object actual) {
    assertSame(null, expected, actual);
  }

  /**
   * Asserts that {@code runnable} throws an exception of type {@code expectedThrowable} when
   * executed. If it does, the exception object is returned. If it does not throw an exception, an
   * {@link AssertionError} is thrown. If it throws the wrong type of exception, an {@code
   * AssertionError} is thrown describing the mismatch; the exception that was actually thrown can
   * be obtained by calling {@link AssertionError#getCause}.
   *
   * @param expectedThrowable the expected type of the exception
   * @param runnable       a function that is expected to throw an exception when executed
   * @return the exception thrown by {@code runnable}
   * @since 4.13
   */
  public static <T extends Throwable> T assertThrows(Class<T> expectedThrowable,
          ThrowingRunnable runnable) {
      return assertThrows(null, expectedThrowable, runnable);
  }

  /**
   * Asserts that {@code runnable} throws an exception of type {@code expectedThrowable} when
   * executed. If it does, the exception object is returned. If it does not throw an exception, an
   * {@link AssertionError} is thrown. If it throws the wrong type of exception, an {@code
   * AssertionError} is thrown describing the mismatch; the exception that was actually thrown can
   * be obtained by calling {@link AssertionError#getCause}.
   *
   * @param message the identifying message for the {@link AssertionError} (<code>null</code>
   * okay)
   * @param expectedThrowable the expected type of the exception
   * @param runnable a function that is expected to throw an exception when executed
   * @return the exception thrown by {@code runnable}
   * @since 4.13
   */
  public static <T extends Throwable> T assertThrows(String message, Class<T> expectedThrowable,
          ThrowingRunnable runnable) {
      try {
          runnable.run();
      } catch (Throwable actualThrown) {
          if (expectedThrowable.isInstance(actualThrown)) {
              @SuppressWarnings("unchecked") T retVal = (T) actualThrown;
              return retVal;
          } else {
              String expected = formatClass(expectedThrowable);
              Class<? extends Throwable> actualThrowable = actualThrown.getClass();
              String actual = formatClass(actualThrowable);
              if (expected.equals(actual)) {
                  // There must be multiple class loaders. Add the identity hash code so the message
                  // doesn't say "expected: java.lang.String<my.package.MyException> ..."
                  expected += "@" + Integer.toHexString(System.identityHashCode(expectedThrowable));
                  actual += "@" + Integer.toHexString(System.identityHashCode(actualThrowable));
              }
              String mismatchMessage = buildPrefix(message)
                      + format("unexpected exception type thrown;", expected, actual);

              // The AssertionError(String, Throwable) ctor is only available on JDK7.
              AssertionError assertionError = new AssertionError(mismatchMessage);
              assertionError.initCause(actualThrown);
              throw assertionError;
          }
      }
      String notThrownMessage = buildPrefix(message) + String
              .format("expected %s to be thrown, but nothing was thrown",
                      formatClass(expectedThrowable));
      throw new AssertionError(notThrownMessage);
  }

  private static String buildPrefix(String message) {
      return message != null && message.length() != 0 ? message + ": " : "";
  }

}
