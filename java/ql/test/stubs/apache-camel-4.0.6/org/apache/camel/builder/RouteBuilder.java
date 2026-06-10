/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.camel.builder;

import org.apache.camel.RoutesBuilder;
import org.apache.camel.model.RouteDefinition;

/**
 * A <a href="http://camel.apache.org/dsl.html">Java DSL</a> which is used to build {@link Route} instances in a
 * {@link CamelContext} for smart routing.
 */
public abstract class RouteBuilder implements RoutesBuilder {

    /**
     * Creates a new route from the given URI input
     *
     * @param  uri the from uri
     * @return     the builder
     */
    public RouteDefinition from(String uri) {
        return null;
    }

    public abstract void configure() throws Exception;
}
