/**
 * Copyright (c) 2008, http://www.snakeyaml.org
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Adapted from SnakeYAML version 1.21 as available at
 *   https://search.maven.org/remotecontent?filepath=org/yaml/snakeyaml/1.21/snakeyaml-1.21-sources.jar
 * Only relevant stubs of this file have been retained for test purposes.
 */

package org.yaml.snakeyaml;

import java.io.InputStream;
import java.io.Reader;
import java.util.Iterator;

import org.yaml.snakeyaml.constructor.BaseConstructor;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.events.Event;

public class Yaml {
    public Yaml() {
    }

    public Yaml(BaseConstructor constructor) {
    }

    public <T> T load(String yaml) {
        return null;
    }

    public <T> T load(InputStream io) {
    	return null;
    }

    public <T> T load(Reader io) {
    	return null;
    }

    public <T> T loadAs(Reader io, Class<T> type) {
    	return null;
    }

    public <T> T loadAs(String yaml, Class<T> type) {
    	return null;
    }

    public <T> T loadAs(InputStream input, Class<T> type) {
    	return null;
    }

    public Iterable<Object> loadAll(Reader yaml) {
    	return null;
    }

    public Iterable<Object> loadAll(String yaml) {
    	return null;
    }

    public Iterable<Object> loadAll(InputStream yaml) {
    	return null;
    }

    public Iterable<Event> parse(Reader yaml) {
    	return null;
    }

}