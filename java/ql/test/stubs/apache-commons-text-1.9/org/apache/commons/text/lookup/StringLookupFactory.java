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

import java.util.Map;
import java.util.function.BiFunction;
import java.util.function.Function;


public final class StringLookupFactory {
    public static final StringLookupFactory INSTANCE = new StringLookupFactory();

    public static void clear() {
    }

    public void addDefaultStringLookups(final Map<String, StringLookup> stringLookupMap) {
    }

    public StringLookup base64DecoderStringLookup() {
      return null;
    }

    public StringLookup base64EncoderStringLookup() {
      return null;
    }

    public StringLookup base64StringLookup() {
      return null;
    }

    public <R, U> BiStringLookup<U> biFunctionStringLookup(final BiFunction<String, U, R> biFunction) {
      return null;
    }

    public StringLookup constantStringLookup() {
      return null;
    }

    public StringLookup dateStringLookup() {
      return null;
    }

    public StringLookup dnsStringLookup() {
      return null;
    }

    public StringLookup environmentVariableStringLookup() {
      return null;
    }

    public StringLookup fileStringLookup() {
      return null;
    }

    public <R> StringLookup functionStringLookup(final Function<String, R> function) {
      return null;
    }

    public StringLookup interpolatorStringLookup() {
      return null;
    }

    public StringLookup interpolatorStringLookup(final Map<String, StringLookup> stringLookupMap,
        final StringLookup defaultStringLookup, final boolean addDefaultLookups) {
      return null;
    }

    public <V> StringLookup interpolatorStringLookup(final Map<String, V> map) {
      return null;
    }

    public StringLookup interpolatorStringLookup(final StringLookup defaultStringLookup) {
      return null;
    }

    public StringLookup javaPlatformStringLookup() {
      return null;
    }

    public StringLookup localHostStringLookup() {
      return null;
    }

    public <V> StringLookup mapStringLookup(final Map<String, V> map) {
      return null;
    }

    public StringLookup nullStringLookup() {
      return null;
    }

    public StringLookup propertiesStringLookup() {
      return null;
    }

    public StringLookup resourceBundleStringLookup() {
      return null;
    }

    public StringLookup resourceBundleStringLookup(final String bundleName) {
      return null;
    }

    public StringLookup scriptStringLookup() {
      return null;
    }

    public StringLookup systemPropertyStringLookup() {
      return null;
    }

    public StringLookup urlDecoderStringLookup() {
      return null;
    }

    public StringLookup urlEncoderStringLookup() {
      return null;
    }

    public StringLookup urlStringLookup() {
      return null;
    }

    public StringLookup xmlStringLookup() {
      return null;
    }

}
