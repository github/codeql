/**
 *
 * Copyright 2003-2004 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

/*
 * Adapted from the Java Servlet API version 2.4 as available at
 *   http://search.maven.org/remotecontent?filepath=javax/servlet/servlet-api/2.4/servlet-api-2.4-sources.jar
 * Only relevant stubs of this file have been retained for test purposes.
 */

package javax.servlet;

import java.io.IOException;
import java.io.OutputStream;

public abstract class ServletOutputStream extends OutputStream {
    protected ServletOutputStream() {
    }
    public void print(String s) throws IOException {
    }
    public void print(boolean b) throws IOException {
    }
    public void print(char c) throws IOException {
    }
    public void print(int i) throws IOException {
    }
    public void print(long l) throws IOException {
    }
    public void print(float f) throws IOException {
    }
    public void print(double d) throws IOException {
    }
    public void println() throws IOException {
    }
    public void println(String s) throws IOException {
    }
    public void println(boolean b) throws IOException {
    }
    public void println(char c) throws IOException {
    }
    public void println(int i) throws IOException {
    }
    public void println(long l) throws IOException {
    }
    public void println(float f) throws IOException {
    }
    public void println(double d) throws IOException {
    }
}
