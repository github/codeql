/*
 * Copyright (C) Lightbend Inc. <https://www.lightbend.com>
 */

package play.mvc;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/** A body parser parses the HTTP request body content. */
public interface BodyParser<A> {

  /**
   * Return an accumulator to parse the body of the given HTTP request.
   *
   * <p>The accumulator should either produce a result if an error was encountered, or the parsed
   * body.
   *
   * @param request The request to create the body parser for.
   * @return The accumulator to parse the body.
   */

  /** Specify the body parser to use for an Action method. */
  @Target({ElementType.TYPE, ElementType.METHOD})
  @Retention(RetentionPolicy.RUNTIME)
  @interface Of {

    /**
     * The class of the body parser to use.
     *
     * @return the class
     */
    //Class<? extends BodyParser> value();
  }

}