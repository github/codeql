/*
 * Copyright (C) Lightbend Inc. <https://www.lightbend.com>
 */

package play.libs;

import java.util.*;
import java.util.concurrent.*;

public class F {
  public static class Promise<A> { // this is needed for play.libs.F for Play 2.3.x
    public static <A> Promise<A> pure(final A a) {
      return null;
    }
  }
}
