/*
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for additional information regarding
 * copyright ownership. The ASF licenses this file to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a
 * copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package org.codehaus.groovy.control;

import groovy.lang.GroovyClassLoader;
import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.util.Iterator;
import java.util.Set;

public class CompilationUnit {
  public CompilationUnit() {}

  public CompilationUnit(final GroovyClassLoader loader) {}

  public Set<javax.tools.JavaFileObject> getJavaCompilationUnitSet() {
    return null;
  }

  public void addJavaCompilationUnits(
      final Set<javax.tools.JavaFileObject> javaCompilationUnitSet) {}

  public GroovyClassLoader getTransformLoader() {
    return null;
  }

  public void addSources(final String[] paths) {}

  public void addSources(final File[] files) {}

  public SourceUnit addSource(final File file) {
    return null;
  }

  public SourceUnit addSource(final URL url) {
    return null;
  }

  public SourceUnit addSource(final String name, final InputStream stream) {
    return null;
  }

  public SourceUnit addSource(final String name, final String scriptText) {
    return null;
  }

  public SourceUnit addSource(final SourceUnit source) {
    return null;
  }

  public Iterator<SourceUnit> iterator() {
    return null;
  }

  public void compile() throws CompilationFailedException {}

  public void compile(int throughPhase) throws CompilationFailedException {}
}
