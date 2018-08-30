/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

/*
 * Adapted from Apache Shiro version 1.4.0 as available at
 *   https://search.maven.org/remotecontent?filepath=org/apache/shiro/shiro-core/1.4.0/shiro-core-1.4.0-sources.jar
 * Only relevant stubs of this file have been retained for test purposes.
 */

package org.apache.shiro.subject;

public interface Subject {

    boolean isPermitted(String permission);

    boolean[] isPermitted(String... permissions);

    boolean isPermittedAll(String... permissions);

}