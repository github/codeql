/*
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

 package org.apache.hc.client5.http.protocol;

 import java.net.URI;
 import java.util.ArrayList;
 import java.util.HashSet;
 import java.util.List;
 import java.util.Set;

 /**
  * This class represents a collection of {@link java.net.URI}s used
  * as redirect locations.
  *
  * @since 4.0
  */
 public final class RedirectLocations {

     private final Set<URI> unique;
     private final List<URI> all;

     public RedirectLocations() {
         super();
         this.unique = new HashSet<>();
         this.all = new ArrayList<>();
     }

     /**
      * Test if the URI is present in the collection.
      */
     public boolean contains(final URI uri) {
         return this.unique.contains(uri);
     }

     /**
      * Adds a new URI to the collection.
      */
     public void add(final URI uri) {
         this.unique.add(uri);
         this.all.add(uri);
     }

     /**
      * Returns all redirect {@link URI}s in the order they were added to the collection.
      *
      * @return list of all URIs
      *
      * @since 4.1
      */
     public List<URI> getAll() {
         return new ArrayList<>(this.all);
     }

     /**
      * Returns the URI at the specified position in this list.
      *
      * @param index
      *            index of the location to return
      * @return the URI at the specified position in this list
      * @throws IndexOutOfBoundsException
      *             if the index is out of range (
      *             {@code index &lt; 0 || index &gt;= size()})
      * @since 4.3
      */
     public URI get(final int index) {
         return this.all.get(index);
     }

     /**
      * Returns the number of elements in this list. If this list contains more
      * than {@code Integer.MAX_VALUE} elements, returns
      * {@code Integer.MAX_VALUE}.
      *
      * @return the number of elements in this list
      * @since 4.3
      */
     public int size() {
         return this.all.size();
     }

     public void clear() {
         unique.clear();
         all.clear();
     }

 }
