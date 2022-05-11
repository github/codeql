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

// Contibutors: Alex Blewitt <Alex.Blewitt@ioshq.com>
// Markus Oestreicher <oes@zurich.ibm.com>
// Frank Hoering <fhr@zurich.ibm.com>
// Nelson Minar <nelson@media.mit.edu>
// Jim Cakalic <jim_cakalic@na.biomerieux.com>
// Avy Sharell <asharell@club-internet.fr>
// Ciaran Treanor <ciaran@xelector.com>
// Jeff Turner <jeff@socialchange.net.au>
// Michael Horwitz <MHorwitz@siemens.co.za>
// Calvin Chan <calvin.chan@hic.gov.au>
// Aaron Greenhouse <aarong@cs.cmu.edu>
// Beat Meier <bmeier@infovia.com.ar>
// Colin Sampaleanu <colinml1@exis.com>

package org.apache.log4j;

import org.apache.log4j.spi.AppenderAttachable;
import org.apache.log4j.spi.LoggingEvent;
import org.apache.log4j.spi.LoggerRepository;
import java.util.Enumeration;
import java.util.ResourceBundle;

public class Category implements AppenderAttachable {
    synchronized public void addAppender(Appender newAppender) {}

    public void assertLog(boolean assertion, String msg) {}

    public void callAppenders(LoggingEvent event) {}

    public void debug(Object message) {}

    public void debug(Object message, Throwable t) {}

    public void error(Object message) {}

    public void error(Object message, Throwable t) {}

    public static Logger exists(String name) {
        return null;
    }

    public void fatal(Object message) {}

    public void fatal(Object message, Throwable t) {}

    public boolean getAdditivity() {
        return false;
    }

    synchronized public Enumeration getAllAppenders() {
        return null;
    }

    synchronized public Appender getAppender(String name) {
        return null;
    }

    public Level getEffectiveLevel() {
        return null;
    }

    public Priority getChainedPriority() {
        return null;
    }

    public static Enumeration getCurrentCategories() {
        return null;
    }

    public static LoggerRepository getDefaultHierarchy() {
        return null;
    }

    public LoggerRepository getHierarchy() {
        return null;
    }

    public LoggerRepository getLoggerRepository() {
        return null;
    }

    public static Category getInstance(String name) {
        return null;
    }

    public static Category getInstance(Class clazz) {
        return null;
    }

    public final String getName() {
        return null;
    }

    final public Category getParent() {
        return null;
    }

    final public Level getLevel() {
        return null;
    }

    final public Level getPriority() {
        return null;
    }

    final public static Category getRoot() {
        return null;
    }

    public ResourceBundle getResourceBundle() {
        return null;
    }

    public void info(Object message) {}

    public void info(Object message, Throwable t) {}

    public boolean isAttached(Appender appender) {
        return false;
    }

    public boolean isDebugEnabled() {
        return false;
    }

    public boolean isEnabledFor(Priority level) {
        return false;
    }

    public boolean isInfoEnabled() {
        return false;
    }

    public void l7dlog(Priority priority, String key, Throwable t) {}

    public void l7dlog(Priority priority, String key, Object[] params, Throwable t) {}

    public void log(Priority priority, Object message, Throwable t) {}

    public void log(Priority priority, Object message) {}

    public void log(String callerFQCN, Priority level, Object message, Throwable t) {}

    synchronized public void removeAllAppenders() {}

    synchronized public void removeAppender(Appender appender) {}

    synchronized public void removeAppender(String name) {}

    public void setAdditivity(boolean additive) {}

    public void setLevel(Level level) {}

    public void setPriority(Priority priority) {}

    public void setResourceBundle(ResourceBundle bundle) {}

    public static void shutdown() {}

    public void warn(Object message) {}

    public void warn(Object message, Throwable t) {}

    public void forcedLog(String fqcn, Priority level, Object message, Throwable t) {}

}
