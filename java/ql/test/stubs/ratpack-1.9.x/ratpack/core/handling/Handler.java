/*
 * Copyright 2013 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ratpack.core.handling;

import ratpack.exec.registry.Registry;

/**
 * A handler participates in the processing of a request/response pair, operating on a {@link Context}.
 * <p>
 * Handlers are the key component of Ratpack applications.
 * A handler either generate a response, or delegate to another handler in some way.
 * </p>
 * <h3>Non blocking/Asynchronous</h3>
 * <p>
 * Handlers are expected to be asynchronous.
 * That is, there is no expectation that the handler is "finished" when its {@link #handle(Context)} method returns.
 * This facilitates the use of non blocking IO without needing to enter some kind of special mode.
 * An implication is that handlers <b>must</b> ensure that they either send a response or delegate to another handler.
 * </p>
 * <h3>Handler pipeline</h3>
 * <p>
 * Handlers are always part of a pipeline structure.
 * The {@link Context} that the handler operates on provides the {@link Context#next()} method that passes control to the next handler in the pipeline.
 * The last handler in the pipeline is always that generates a {@code 404} client error.
 * <p>
 * Handlers can themselves insert other handlers into the pipeline, using the {@link Context#insert(Handler...)} family of methods.
 * <h3>Examples</h3>
 * While there is no strict taxonomy of handlers, the following are indicative examples of common functions.
 *
 * <pre class="tested">
 * import ratpack.core.handling.*;
 *
 * // A responder may just return a response to the client
 *
 * class SimpleHandler implements Handler {
 *   void handle(Context exchange) {
 *     exchange.getResponse().send("Hello World!");
 *   }
 * }
 *
 * // A responder may add a response header, before delegating to the next in the pipeline
 *
 * class DecoratingHandler implements Handler {
 *   void handle(Context exchange) {
 *     exchange.getResponse().getHeaders().set("Cache-Control", "no-cache");
 *     exchange.next();
 *   }
 * }
 *
 * // Or a handler may conditionally respond
 *
 * class ConditionalHandler implements Handler {
 *   void handle(Context exchange) {
 *     if (exchange.getRequest().getPath().equals("foo")) {
 *       exchange.getResponse().send("Hello World!");
 *     } else {
 *       exchange.next();
 *     }
 *   }
 * }
 *
 * // A handler does not need to participate in the response, but can instead "route" the exchange to different handlers
 *
 * class RoutingHandler implements Handler {
 *   private final Handler[] fooHandlers;
 *
 *   public RoutingHandler(Handler... fooHandlers) {
 *     this.fooHandlers = fooHandlers;
 *   }
 *
 *   void handle(Context exchange) {
 *     if (exchange.getRequest().getPath().startsWith("foo/")) {
 *       exchange.insert(fooHandlers);
 *     } else {
 *       exchange.next();
 *     }
 *   }
 * }
 *
 * // It can sometimes be appropriate to directly delegate to a handler, instead of using exchange.insert()
 *
 * class FilteringHandler implements Handler {
 *   private final Handler nestedHandler;
 *
 *   public FilteringHandler(Handler nestedHandler) {
 *     this.nestedHandler = nestedHandler;
 *   }
 *
 *   void handle(Context exchange) {
 *     if (exchange.getRequest().getPath().startsWith("foo/")) {
 *       nestedHandler.handle(exchange);
 *     } else {
 *       exchange.next();
 *     }
 *   }
 * }
 * </pre>
 *
 * @see Handlers
 * @see Chain
 * @see Registry
 */
@FunctionalInterface
public interface Handler {

  /**
   * Handles the context.
   *
   * @param ctx The context to handle
   * @throws Exception if anything goes wrong (exception will be implicitly passed to the context's {@link Context#error(Throwable)} method)
   */
  void handle(Context ctx) throws Exception;

}
