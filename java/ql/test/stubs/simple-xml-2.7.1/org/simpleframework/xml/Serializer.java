/*
 * Serializer.java July 2006
 *
 * Copyright (C) 2006, Niall Gallagher <niallg@users.sf.net>
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

package org.simpleframework.xml;

import java.io.InputStream;
import java.io.Reader;
import java.io.File;

public interface Serializer {
   
 <T> T read(Class<? extends T> type, String source) throws Exception;
        
 <T> T read(Class<? extends T> type, File source) throws Exception;

 <T> T read(Class<? extends T> type, InputStream source) throws Exception;

 <T> T read(Class<? extends T> type, Reader source) throws Exception;
   
 <T> T read(Class<? extends T> type, String source, boolean strict) throws Exception;

 <T> T read(Class<? extends T> type, File source, boolean strict) throws Exception;

 <T> T read(Class<? extends T> type, InputStream source, boolean strict) throws Exception;

 <T> T read(Class<? extends T> type, Reader source, boolean strict) throws Exception;
   
 <T> T read(T value, String source) throws Exception;
        
 <T> T read(T value, File source) throws Exception;

 <T> T read(T value, InputStream source) throws Exception;

 <T> T read(T value, Reader source) throws Exception;
   
 <T> T read(T value, String source, boolean strict) throws Exception;
        
 <T> T read(T value, File source, boolean strict) throws Exception;

 <T> T read(T value, InputStream source, boolean strict) throws Exception;

 <T> T read(T value, Reader source, boolean strict) throws Exception;
   
 boolean validate(Class type, String source) throws Exception;

 boolean validate(Class type, File source) throws Exception;

 boolean validate(Class type, InputStream source) throws Exception;

 boolean validate(Class type, Reader source) throws Exception;
   
 boolean validate(Class type, String source, boolean strict) throws Exception;
        
 boolean validate(Class type, File source, boolean strict) throws Exception;

 boolean validate(Class type, InputStream source, boolean strict) throws Exception;

 boolean validate(Class type, Reader source, boolean strict) throws Exception;
}
