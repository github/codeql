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
    private String name; // NAME= ... "$Name" style is reserved
    private String value; // value of NAME
    private String comment; // ;Comment=VALUE ... describes cookie's use
    private String domain; // ;Domain=VALUE ... domain that sees cookie
    private int maxAge = -1; // ;Max-Age=VALUE ... cookies auto-expire
    private String path; // ;Path=VALUE ... URLs that see the cookie
    private boolean secure; // ;Secure ... e.g. use SSL
    private int version = 0; // ;Version=1 ... means RFC 2109++ style

    public Cookie(String name, String value) {
        this.name = name;
        this.value = value;
    }
    public void setComment(String purpose) {
        comment = purpose;
    }
    public String getComment() {
        return comment;
    }
    public void setDomain(String pattern) {
        domain = pattern.toLowerCase(); // IE allegedly needs this
    }
    public String getDomain() {
        return domain;
    }
    public void setMaxAge(int expiry) {
        maxAge = expiry;
    }
    public int getMaxAge() {
        return maxAge;
    }
    public void setPath(String uri) {
        path = uri;
    }
    public String getPath() {
        return path;
    }
    public void setSecure(boolean flag) {
        secure = flag;
    }
    public boolean getSecure() {
        return secure;
    }
    public String getName() {
        return name;
    }
    public void setValue(String newValue) {
        value = newValue;
    }
    public String getValue() {
        return value;
    }
    public int getVersion() {
        return version;
    }
    public void setVersion(int v) {
    }
}
