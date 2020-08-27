/*
 * $HeadURL: http://svn.apache.org/repos/asf/httpcomponents/httpcore/trunk/module-main/src/main/java/org/apache/http/HeaderElementIterator.java $
 * $Revision: 584542 $
 * $Date: 2007-10-14 06:29:34 -0700 (Sun, 14 Oct 2007) $
 *
 * ====================================================================
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */

package org.apache.http;

import java.util.Iterator;

/**
 * A type-safe iterator for {@link HeaderElement HeaderElement} objects.
 * 
 * @version $Revision: 584542 $
 *
 * @deprecated Please use {@link java.net.URL#openConnection} instead.
 *     Please visit <a href="http://android-developers.blogspot.com/2011/09/androids-http-clients.html">this webpage</a>
 *     for further details.
 */
@Deprecated
public interface HeaderElementIterator extends Iterator {
    
    /**
     * Indicates whether there is another header element in this 
     * iteration.
     *
     * @return  <code>true</code> if there is another header element,
     *          <code>false</code> otherwise
     */
    boolean hasNext();
    
    /**
     * Obtains the next header element from this iteration.
     * This method should only be called while {@link #hasNext hasNext}
     * is true.
     *
     * @return  the next header element in this iteration
     */
    HeaderElement nextElement();
    
}
