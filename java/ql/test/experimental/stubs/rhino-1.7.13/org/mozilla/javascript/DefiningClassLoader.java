/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

 package org.mozilla.javascript;

 /**
  * Load generated classes.
  *
  * @author Norris Boyd
  */
 public class DefiningClassLoader extends ClassLoader
     implements GeneratedClassLoader
 {
     public DefiningClassLoader() {
     }
 
     public DefiningClassLoader(ClassLoader parentLoader) {
     }
 
     @Override
     public Class<?> defineClass(String name, byte[] data) {
         return null;
     }
 
     @Override
     public void linkClass(Class<?> cl) {
     }
 
     @Override
     public Class<?> loadClass(String name, boolean resolve)
         throws ClassNotFoundException
     {
         return null;
     }
 }