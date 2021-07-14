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

public class Cookie implements Cloneable {

    public Cookie(String name, String value) {
    }
    public void setComment(String purpose) {
    }
    public String getComment() {
        return null;
    }
    public void setDomain(String pattern) {
    }
    public String getDomain() {
        return null;
    }
    public void setMaxAge(int expiry) {
    }
    public int getMaxAge() {
        return -1;
    }
    public void setPath(String uri) {
    }
    public String getPath() {
        return null;
    }
    public void setSecure(boolean flag) {
    }
    public boolean getSecure() {
        return false;
    }
    public String getName() {
        return null;
    }
    public void setValue(String newValue) {
    }
    public String getValue() {
        return null;
    }
    public int getVersion() {
        return -1;
    }
    public void setVersion(int v) {
    }
    public void setHttpOnly(boolean isHttpOnly) {
    }
    public boolean isHttpOnly() {
        return false;
    }

    /**
     * Convert the cookie to a string suitable for use as the value of the
     * corresponding HTTP header.
     *
     * @return a stringified cookie.
     */
    @Override
    public String toString() {
        return null;
    }    
}
