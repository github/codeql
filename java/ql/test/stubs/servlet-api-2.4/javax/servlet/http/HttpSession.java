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

package javax.servlet.http;

import java.util.Enumeration;
import javax.servlet.ServletContext;

public interface HttpSession {
    public long getCreationTime();
    public String getId();
    public long getLastAccessedTime();
    public ServletContext getServletContext();
    public void setMaxInactiveInterval(int interval);
    public int getMaxInactiveInterval();
    public HttpSessionContext getSessionContext();
    public Object getAttribute(String name);
    public Object getValue(String name);
    public Enumeration getAttributeNames();
    public String[] getValueNames();
    public void setAttribute(String name, Object value);
    public void putValue(String name, Object value);
    public void removeAttribute(String name);
    public void removeValue(String name);
    public void invalidate();
    public boolean isNew();
}
