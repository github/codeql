/*
 * Copyright 2015-2018 the original author or authors.
 *
 * All rights reserved. This program and the accompanying materials are
 * made available under the terms of the Eclipse Public License v2.0 which
 * accompanies this distribution and is available at
 *
 * http://www.eclipse.org/legal/epl-v20.html
 */

/*
 * MODIFIED version of junit-jupiter-api 5.2.0 as available at
 *   https://search.maven.org/classic/remotecontent?filepath=org/junit/jupiter/junit-jupiter-api/5.2.0/junit-jupiter-api-5.2.0-sources.jar
 * Only parts of this file have been retained for test purposes.
 */

package org.junit.jupiter.api;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ ElementType.ANNOTATION_TYPE, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Test {
}
