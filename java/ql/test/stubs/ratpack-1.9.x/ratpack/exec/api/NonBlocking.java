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

package ratpack.exec.api;

import java.lang.annotation.*;

/**
 * Declares that a method or function-like method parameter is non-blocking and can freely use {@link ratpack.exec.Promise} and other async constructs.
 * <p>
 * If this annotation is present on a method, it indicates that the method may be asynchronous.
 * That is, it is not necessarily expected to have completed its logical work when the method returns.
 * The method must however use {@link ratpack.exec.Promise}, {@link ratpack.exec.Operation}, or other execution mechanisms to perform asynchronous work.
 * <p>
 * Most such methods are invoked as part of Ratpack.
 * If you need to invoke such a method, do so as part of a discrete {@link ratpack.exec.Operation}.
 * <p>
 * If this annotation is present on a function type method parameter, it indicates that the annotated function may be asynchronous.
 * Similarly, if you need to invoke such a parameter, do so as part of a discrete {@link ratpack.exec.Operation}.
 * <p>
 * <b>Note:</b> the ability to annotate method parameters with this annotation was added in version {@code 1.1.0}.
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD, ElementType.PARAMETER})
public @interface NonBlocking {
}
