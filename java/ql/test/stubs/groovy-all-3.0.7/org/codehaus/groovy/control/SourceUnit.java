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
import org.codehaus.groovy.control.io.ReaderSource;
import java.io.File;
import java.net.URL;

public class SourceUnit {
  public SourceUnit(String name, ReaderSource source, CompilerConfiguration flags,
      GroovyClassLoader loader, ErrorCollector er) {}

  public SourceUnit(File source, CompilerConfiguration configuration, GroovyClassLoader loader,
      ErrorCollector er) {}

  public SourceUnit(URL source, CompilerConfiguration configuration, GroovyClassLoader loader,
      ErrorCollector er) {}

  public SourceUnit(String name, String source, CompilerConfiguration configuration,
      GroovyClassLoader loader, ErrorCollector er) {}

  public String getName() {
    return null;
  }

  public boolean failedWithUnexpectedEOF() {
    return false;
  }

  public static SourceUnit create(String name, String source) {
    return null;
  }

  public static SourceUnit create(String name, String source, int tolerance) {
    return null;
  }

  public void parse() throws CompilationFailedException {}

  public void convert() throws CompilationFailedException {}

  public void addException(Exception e) throws CompilationFailedException {}

  public ReaderSource getSource() {
    return null;
  }

  public void setSource(ReaderSource source) {}

}
