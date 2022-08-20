/*
 * Copyright (C) 2015 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package android.annotation;

import java.lang.annotation.Target;
import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.PARAMETER;

public @interface RequiresPermission {
    String value() default "";

    String[] allOf() default {};

    String[] anyOf() default {};

    boolean conditional() default false;

    @Target({FIELD, METHOD, PARAMETER})

    @interface Read {
        RequiresPermission value() default @RequiresPermission;

    }
    @Target({FIELD, METHOD, PARAMETER})

    @interface Write {
        RequiresPermission value() default @RequiresPermission;

    }
}
