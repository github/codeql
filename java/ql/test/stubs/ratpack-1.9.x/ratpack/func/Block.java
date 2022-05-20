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

package ratpack.func;

import ratpack.exec.Operation;

/**
 * A block of code.
 * <p>
 * Similar to {@link Runnable}, but allows throwing of checked exceptions.
 */
@FunctionalInterface
public interface Block {

  static Block noop() {
    return null;
  }

  void execute() throws Exception;

  static Block throwException(final Throwable throwable) {
    return null;
  }

  default Runnable toRunnable() {
    return null;
  }

  default Action<Object> action() {
    return null;
  }

  default <T> T map(Function<? super Block, ? extends T> function) {
    return null;
  }
}
