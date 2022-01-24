/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache license, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the license for the specific language governing permissions and
 * limitations under the license.
 */

package org.apache.commons.text.lookup;

/**
 * Lookups a String key for a String value.
 * <p>
 * This class represents the simplest form of a string to string map. It has a benefit over a map in that it can create
 * the result on demand based on the key.
 * </p>
 * <p>
 * For example, it would be possible to implement a lookup that used the key as a primary key, and looked up the value
 * on demand from the database.
 * </p>
 *
 * @since 1.3
 */
@FunctionalInterface
public interface StringLookup {
    String lookup(String key);

}
