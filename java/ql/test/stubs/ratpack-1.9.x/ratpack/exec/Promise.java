/*
 * Copyright 2014 the original author or authors.
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

package ratpack.exec;

import ratpack.func.Action;
import ratpack.func.Function;

/**
 * A promise for a single value.
 * <p>
 * A promise is a representation of a value which will become available later.
 * Methods such as {@link #map(Function)}, {@link #flatMap(Function)}, {@link #cache()} etc.) allow a pipeline of “operations” to be specified,
 * that the value will travel through as it becomes available.
 * Such operations are implemented via the {@link #transform(Function)} method.
 * Each operation returns a new promise object, not the original promise object.
 * <p>
 * To create a promise, use the {@link Promise#async(Upstream)} method (or one of the variants such as {@link Promise#sync(Factory)}.
 * To test code that uses promises, use the {@link ratpack.test.exec.ExecHarness}.
 * <p>
 * The promise is not “activated” until the {@link #then(Action)} method is called.
 * This method terminates the pipeline, and receives the final value.
 * <p>
 * Promise objects are multi use.
 * Every promise pipeline has a value producing function at its start.
 * Activating a promise (i.e. calling {@link #then(Action)}) invokes the function.
 * The {@link #cache()} operation can be used to change this behaviour.
 *
 * @param <T> the type of promised value
 */
@SuppressWarnings("JavadocReference")
public interface Promise<T> {
  <O> Promise<O> map(Function<? super T, ? extends O> transformer);

  void then(Action<? super T> then);

  Promise<T> next(Action<? super T> action);
}
