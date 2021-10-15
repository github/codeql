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
package org.codehaus.groovy.tools.javac;

import groovy.lang.GroovyClassLoader;
import org.codehaus.groovy.control.CompilationFailedException;
import org.codehaus.groovy.control.CompilationUnit;
import org.codehaus.groovy.control.CompilerConfiguration;
import org.codehaus.groovy.control.SourceUnit;
import java.io.File;
import java.net.URL;

public class JavaStubCompilationUnit extends CompilationUnit {
  public JavaStubCompilationUnit(final CompilerConfiguration config, final GroovyClassLoader gcl,
      File destDir) {}

  public JavaStubCompilationUnit(final CompilerConfiguration config, final GroovyClassLoader gcl) {}

  public int getStubCount() {
    return 0;
  }

  @Override
  public void compile() throws CompilationFailedException {}

  @Override
  public SourceUnit addSource(final File file) {
    return null;
  }

  @Override
  public SourceUnit addSource(URL url) {
    return null;
  }

}
