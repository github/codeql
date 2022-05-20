/*
 * Provider.java January 2010
 *
 * Copyright (C) 2010, Niall Gallagher <niallg@users.sf.net>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
 * implied. See the License for the specific language governing 
 * permissions and limitations under the License.
 */

/*
 * Adapted from Simple XML serialization framework version 2.7.1 as available at
 *   https://search.maven.org/remotecontent?filepath=org/simpleframework/simple-xml/2.7.1/simple-xml-2.7.1-sources.jar
 * Only relevant stubs of this file have been retained for test purposes.
 */

package org.simpleframework.xml.stream;

import java.io.InputStream;
import java.io.Reader;

interface Provider {

  void provide(InputStream source) throws Exception;

  void provide(Reader source) throws Exception;
}
