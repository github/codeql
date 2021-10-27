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

import com.google.common.reflect.TypeToken;
import ratpack.core.http.*;
import ratpack.core.parse.Parse;
import ratpack.core.render.*;
import ratpack.exec.api.NonBlocking;
import ratpack.exec.registry.NotInRegistryException;
import ratpack.exec.registry.Registry;
import ratpack.exec.Promise;

import java.nio.file.Path;
import java.time.Instant;
import java.util.Arrays;
import java.util.Date;
import java.util.Optional;

/**
 * The context of an individual {@link Handler} invocation.
 * <p>
 * It provides:
 * <ul>
 * <li>Access the HTTP {@link #getRequest() request} and {@link #getResponse() response}</li>
 * <li>Delegation (via the {@link #next} and {@link #insert} family of methods)</li>
 * <li>Access to <i>contextual objects</i> (see below)</li>
 * <li>Convenience for common handler operations</li>
 * </ul>
 *
 * <h3>Contextual objects</h3>
 * <p>
 * A context is also a {@link Registry} of objects.
 * Arbitrary objects can be "pushed" into the context for use by <i>downstream</i> handlers.
 * <p>
 * There are some significant contextual objects that drive key infrastructure.
 * For example, error handling is based on informing the contextual {@link ServerErrorHandler} of exceptions.
 * The error handling strategy for an application can be changed by pushing a new implementation of this interface into the context that is used downstream.
 * <p>
 * See {@link #insert(Handler...)} for more on how to do this.
 * <h4>Default contextual objects</h4>
 * <p>There is also a set of default objects that are made available via the Ratpack infrastructure:
 * <ul>
 * <li>A {@link FileSystemBinding} that is the application {@link ServerConfig#getBaseDir()}</li>
 * <li>A {@link MimeTypes} implementation</li>
 * <li>A {@link ServerErrorHandler}</li>
 * <li>A {@link ClientErrorHandler}</li>
 * <li>A {@link PublicAddress}</li>
 * <li>A {@link Redirector}</li>
 * </ul>
 */
public interface Context extends Registry {

  /**
   * A type token for this type.
   *
   * @since 1.1
   */
  TypeToken<Context> TYPE = null;

  /**
   * Returns this.
   *
   * @return this.
   */
  Context getContext();

  /**
   * The HTTP request.
   *
   * @return The HTTP request.
   */
  Request getRequest();

  /**
   * The HTTP response.
   *
   * @return The HTTP response.
   */
  Response getResponse();

  /**
   * Delegate handling to the next handler in line.
   * <p>
   * The request and response of this object should not be accessed after this method is called.
   */
  @NonBlocking
  void next();

  /**
   * Invokes the next handler, after adding the given registry.
   * <p>
   * The given registry is appended to the existing.
   * This means that it can shadow objects previously available.
   * <pre class="java">{@code
   * import ratpack.exec.registry.Registry;
   * import ratpack.test.embed.EmbeddedApp;
   *
   * import static org.junit.Assert.assertEquals;
   *
   * public class Example {
   *
   *   public static void main(String... args) throws Exception {
   *     EmbeddedApp.fromHandlers(chain -> chain
   *         .all(ctx -> ctx.next(Registry.single("foo")))
   *         .all(ctx -> ctx.render(ctx.get(String.class)))
   *     ).test(httpClient -> {
   *       assertEquals("foo", httpClient.getText());
   *     });
   *   }
   * }
   * }</pre>
   *
   * @param registry The registry to make available for subsequent handlers.
   */
  @NonBlocking
  void next(Registry registry);

  /**
   * Inserts some handlers into the pipeline, then delegates to the first.
   * <p>
   * The request and response of this object should not be accessed after this method is called.
   *
   * @param handlers The handlers to insert.
   */
  @NonBlocking
  void insert(Handler... handlers);

  /**
   * Inserts some handlers into the pipeline to execute with the given registry, then delegates to the first.
   * <p>
   * The given registry is only applicable to the inserted handlers.
   * <p>
   * Almost always, the registry should be a super set of the current registry.
   *
   * @param handlers The handlers to insert
   * @param registry The registry for the inserted handlers
   */
  @NonBlocking
  void insert(Registry registry, Handler... handlers);

 
  /**
   * Handles any error thrown during request handling.
   * <p>
   * Uncaught exceptions that are thrown any time during request handling will end up here.
   * <p>
   * Forwards the exception to the {@link ServerErrorHandler} within the current registry.
   * Add an implementation of this interface to the registry to handle errors.
   * The default implementation is not suitable for production usage.
   * <p>
   * If the exception is-a {@link ClientErrorException},
   * the {@link #clientError(int)} method will be called with the exception's status code
   * instead of being forward to the server error handler.
   *
   * @param throwable The exception that occurred
   */
  @NonBlocking
  void error(Throwable throwable);

  /**
   * Forwards the error to the {@link ClientErrorHandler} in this service.
   *
   * The default configuration of Ratpack includes a {@link ClientErrorHandler} in all contexts.
   * A {@link NotInRegistryException} will only be thrown if a very custom service setup is being used.
   *
   * @param statusCode The 4xx range status code that indicates the error type
   * @throws NotInRegistryException if no {@link ClientErrorHandler} can be found in the service
   */
  @NonBlocking
  void clientError(int statusCode) throws NotInRegistryException;

  /**
   * Render the given object, using the rendering framework.
   * <p>
   * The first {@link Renderer}, that is able to render the given object will be delegated to.
   * If the given argument is {@code null}, this method will have the same effect as {@link #clientError(int) clientError(404)}.
   * <p>
   * If no renderer can be found for the given type, a {@link NoSuchRendererException} will be given to {@link #error(Throwable)}.
   * <p>
   * If a renderer throws an exception during its execution it will be wrapped in a {@link RendererException} and given to {@link #error(Throwable)}.
   * <p>
   * Ratpack has built in support for rendering the following types:
   * <ul>
   * <li>{@link Path}</li>
   * <li>{@link CharSequence}</li>
   * <li>{@link JsonRender} (Typically created via {@link Jackson#json(Object)})</li>
   * <li>{@link Promise} (renders the promised value, using this {@code render()} method)</li>
   * <li>{@link Publisher} (converts the publisher to a promise using {@link Streams#toPromise(Publisher)} and renders it)</li>
   * <li>{@link Renderable} (Delegates to the {@link Renderable#render(Context)} method of the object)</li>
   * </ul>
   * <p>
   * See {@link Renderer} for more on how to contribute to the rendering framework.
   * <p>
   * The object-to-render will be decorated by all registered {@link RenderableDecorator} whose type is exactly equal to the type of the object-to-render, before being passed to the selected renderer.
   *
   * @param object The object-to-render
   * @throws NoSuchRendererException if no suitable renderer can be found
   */
  @NonBlocking
  void render(Object object) throws NoSuchRendererException;

  /**
   * Returns the request header with the specified name.
   * <p>
   * If there is more than value for the specified header, the first value is returned.
   * <p>
   * Shorthand for {@code getRequest().getHeaders().get(String)}.
   *
   * @param name the case insensitive name of the header to get retrieve the first value of
   * @return the header value or {@code null} if there is no such header
   * @since 1.4
   */
  default Optional<String> header(CharSequence name) {
    return Optional.ofNullable(getRequest().getHeaders().get(name));
  }

  /**
   * Sets a response header.
   * <p>
   * Any previously set values for the header will be removed.
   * <p>
   * Shorthand for {@code getResponse().getHeaders().set(CharSequence, Iterable)}.
   *
   * @param name the name of the header to set
   * @param values the header values
   * @return {@code this}
   * @since 1.4
   * @see MutableHeaders#set(CharSequence, Iterable)
   */
  default Context header(CharSequence name, Object... values) {
    getResponse().getHeaders().set(name, Arrays.asList(values));
    return this;
  }

  /**
   * Sends a temporary redirect response (i.e. 302) to the client using the specified redirect location.
   *
   * @param to the location to redirect to
   * @see #redirect(int, Object)
   * @since 1.3
   */
  void redirect(Object to);

  /**
   * Sends a redirect response to the given location, and with the given status code.
   * <p>
   * This method retrieves the {@link Redirector} from the registry, and forwards the given arguments along with {@code this} context.
   *
   * @param code The status code of the redirect
   * @param to the redirect location URL
   * @see Redirector
   * @since 1.3
   */
  void redirect(int code, Object to);

  /**
   * Convenience method for handling last-modified based HTTP caching.
   * <p>
   * The given date is the "last modified" value of the response.
   * If the client sent an "If-Modified-Since" header that is of equal or greater value than date,
   * a 304 will be returned to the client.
   * Otherwise, the given runnable will be executed (it should send a response)
   * and the "Last-Modified" header will be set by this method.
   *
   * @param lastModified the effective last modified date of the response
   * @param serve the response sending action if the response needs to be sent
   */
  @NonBlocking
  default void lastModified(Date lastModified, Runnable serve) {
    lastModified(lastModified.toInstant(), serve);
  }

  /**
   * Convenience method for handling last-modified based HTTP caching.
   * <p>
   * The given date is the "last modified" value of the response.
   * If the client sent an "If-Modified-Since" header that is of equal or greater value than date,
   * a 304 will be returned to the client.
   * Otherwise, the given runnable will be executed (it should send a response)
   * and the "Last-Modified" header will be set by this method.
   *
   * @param lastModified the effective last modified date of the response
   * @param serve the response sending action if the response needs to be sent
   * @since 1.4
   */
  @NonBlocking
  void lastModified(Instant lastModified, Runnable serve);

  /**
   * Parse the request into the given type, using no options (or more specifically an instance of {@link NullParseOpts} as the options).
   * <p>
   * The code sample is functionally identical to the sample given for the {@link #parse(Parse)} variant
   * <pre class="java">{@code
   * import ratpack.core.handling.Handler;
   * import ratpack.core.handling.Context;
   * import ratpack.core.form.Form;
   *
   * public class FormHandler implements Handler {
   *   public void handle(Context context) {
   *     context.parse(Form.class).then(form -> context.render(form.get("someFormParam")));
   *   }
   * }
   * }</pre>
   * <p>
   * That is, it is a convenient form of {@code parse(Parse.of(T))}.
   *
   * @param type the type to parse to
   * @param <T> the type to parse to
   * @return a promise for the parsed object
   */
  <T> Promise<T> parse(Class<T> type);

  /**
   * Parse the request into the given type, using no options (or more specifically an instance of {@link NullParseOpts} as the options).
   * <p>
   * The code sample is functionally identical to the sample given for the {@link #parse(Parse)} variant&hellip;
   * <pre class="java">{@code
   * import ratpack.core.handling.Handler;
   * import ratpack.core.handling.Context;
   * import ratpack.core.form.Form;
   * import com.google.common.reflect.TypeToken;
   *
   * public class FormHandler implements Handler {
   *   public void handle(Context context) {
   *     context.parse(new TypeToken<Form>() {}).then(form -> context.render(form.get("someFormParam")));
   *   }
   * }
   * }</pre>
   * <p>
   * That is, it is a convenient form of {@code parse(Parse.of(T))}.
   *
   * @param type the type to parse to
   * @param <T> the type to parse to
   * @return a promise for the parsed object
   */
  <T> Promise<T> parse(TypeToken<T> type);

  /**
   * Constructs a {@link Parse} from the given args and delegates to {@link #parse(Parse)}.
   *
   * @param type The type to parse to
   * @param options The parse options
   * @param <T> The type to parse to
   * @param <O> The type of the parse opts
   * @return a promise for the parsed object
   */
  <T, O> Promise<T> parse(Class<T> type, O options);

  /**
   * Constructs a {@link Parse} from the given args and delegates to {@link #parse(Parse)}.
   *
   * @param type The type to parse to
   * @param options The parse options
   * @param <T> The type to parse to
   * @param <O> The type of the parse opts
   * @return a promise for the parsed object
   */
  <T, O> Promise<T> parse(TypeToken<T> type, O options);

  /**
   * Parses the request body into an object.
   * <p>
   * How to parse the request is determined by the given {@link Parse} object.
   *
   * <h3>Parser Resolution</h3>
   * <p>
   * Parser resolution happens as follows:
   * <ol>
   * <li>All {@link Parser parsers} are retrieved from the context registry (i.e. {@link #getAll(Class) getAll(Parser.class)});</li>
   * <li>Found parsers are checked (in order returned by {@code getAll()}) for compatibility with the options type;</li>
   * <li>If a parser is found that is compatible, its {@link Parser#parse(Context, TypedData, Parse)} method is called;</li>
   * <li>If the parser returns {@code null} the next parser will be tried, if it returns a value it will be returned by this method;</li>
   * <li>If no compatible parser could be found, a {@link NoSuchParserException} will be thrown.</li>
   * </ol>
   *
   * <h3>Parser Compatibility</h3>
   * <p>
   * A parser is compatible if all of the following hold true:
   * <ul>
   * <li>The opts of the given {@code parse} object is an {@code instanceof} its {@link Parser#getOptsType()}, or the opts are {@code null}.</li>
   * <li>The {@link Parser#parse(Context, TypedData, Parse)} method returns a non null value.</li>
   * </ul>
   *
   * <h3>Core Parsers</h3>
   * <p>
   * Ratpack core provides parsers for {@link Form}, and JSON (see {@link Jackson}).
   *
   * <h3>Example Usage</h3>
   * <pre class="java">{@code
   * import ratpack.core.handling.Handler;
   * import ratpack.core.handling.Context;
   * import ratpack.core.form.Form;
   * import ratpack.core.parse.NullParseOpts;
   *
   * public class FormHandler implements Handler {
   *   public void handle(Context context) {
   *     context.parse(Form.class).then(form -> context.render(form.get("someFormParam")));
   *   }
   * }
   * }</pre>
   *
   * @param parse The specification of how to parse the request
   * @param <T> The type of object the request is parsed into
   * @param <O> the type of the parse options object
   * @return a promise for the parsed object
   * @see #parse(Class)
   * @see #parse(Class, Object)
   * @see Parser
   */
  <T, O> Promise<T> parse(Parse<T, O> parse);

  /**
   * Parses the provided request body into an object.
   * <p>
   * This variant can be used when a reference to the request body has already been obtained.
   * For example, this can be used during the implementation of a {@link Parser} that needs to delegate to another parser.
   * <p>
   * From within a handler, it is more common to use {@link #parse(Parse)} or similar.
   *
   * @param body The request body
   * @param parse The specification of how to parse the request
   * @param <T> The type of object the request is parsed into
   * @param <O> The type of the parse options object
   * @return a promise for the parsed object
   * @see #parse(Parse)
   * @throws Exception any thrown by the parser
   */
  <T, O> T parse(TypedData body, Parse<T, O> parse) throws Exception;

  /**
   * Gets the file relative to the contextual {@link FileSystemBinding}.
   * <p>
   * Shorthand for {@code get(FileSystemBinding.class).file(path)}.
   * <p>
   * The default configuration of Ratpack includes a {@link FileSystemBinding} in all contexts.
   * A {@link NotInRegistryException} will only be thrown if a very custom service setup is being used.
   *
   * @param path The path to pass to the {@link FileSystemBinding#file(String)} method.
   * @return The file relative to the contextual {@link FileSystemBinding}
   * @throws NotInRegistryException if there is no {@link FileSystemBinding} in the current service
   */
  Path file(String path) throws NotInRegistryException;

  /**
   * Issues a 404 client error.
   * <p>
   * This method is literally a shorthand for {@link #clientError(int) clientError(404)}.
   * <p>
   * This is a terminal handler operation.
   *
   * @since 1.1
   */
  default void notFound() {
    clientError(404);
  }

}
