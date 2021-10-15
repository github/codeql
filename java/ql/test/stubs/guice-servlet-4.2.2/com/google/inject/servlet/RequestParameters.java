/*
 * Copyright (C) 2006 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Adapted from Guice Servlet version 4.2.2 as available at
 *   https://search.maven.org/classic/remotecontent?filepath=com/google/inject/extensions/guice-servlet/4.2.2/guice-servlet-4.2.2-sources.jar
 * Only relevant stubs of this file have been retained for test purposes.
 */

package com.google.inject.servlet;

import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * Apply this to field or parameters of type {@code Map<String, String[]>} when you want the HTTP
 * request parameter map to be injected.
 *
 * @author crazybob@google.com (Bob Lee)
 */
@Retention(RUNTIME)
@Target({ElementType.FIELD, ElementType.PARAMETER, ElementType.METHOD})
public @interface RequestParameters {}
