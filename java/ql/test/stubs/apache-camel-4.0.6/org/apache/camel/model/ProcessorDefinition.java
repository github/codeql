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
package org.apache.camel.model;

import org.apache.camel.builder.ExpressionClause;

public abstract class ProcessorDefinition<Type extends ProcessorDefinition<Type>> {

  public Type to(String uri) { return null; }
  public Type bean(Object bean) { return null; }
  public Type bean(Class<?> beanType) { return null; }
  // Restored method deprecated in ee8af5e8157e7595b031b83500cc9c02b7f5c679
  public Type beanRef(String ref) { return null; }
  public ExpressionClause<? extends FilterDefinition> filter() { return null; }

}
