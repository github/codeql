/*
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for additional information regarding
 * copyright ownership. The ASF licenses this file to You under the Apache License, Version 2.0 (the
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

package org.apache.log4j.spi;

import java.util.Map;
import java.util.Set;
import org.apache.log4j.Category;
import org.apache.log4j.Level;
import org.apache.log4j.Priority;

public class LoggingEvent implements java.io.Serializable {
  public LoggingEvent(String fqnOfCategoryClass, Category logger, Priority level, Object message,
      Throwable throwable) {}

  public LoggingEvent(String fqnOfCategoryClass, Category logger, long timeStamp, Priority level,
      Object message, Throwable throwable) {}

  public Level getLevel() {
    return null;
  }

  public String getLoggerName() {
    return null;
  }

  public Category getLogger() {
    return null;
  }

  public static long getStartTime() {
    return 0;
  }

  public final void setProperty(final String propName, final String propValue) {}

  public final String getProperty(final String key) {
    return null;
  }

  public final boolean locationInformationExists() {
    return false;
  }

  public final long getTimeStamp() {
    return 0;
  }

  public Set getPropertyKeySet() {
    return null;
  }

  public Map getProperties() {
    return null;
  }

  public String getFQNOfLoggerClass() {
    return null;
  }

  public Object removeProperty(String propName) {
    return null;
  }

}
