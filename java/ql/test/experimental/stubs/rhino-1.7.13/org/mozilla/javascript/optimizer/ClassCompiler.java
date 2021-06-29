/* -*- Mode: java; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

 package org.mozilla.javascript.optimizer;
 
 import org.mozilla.javascript.CompilerEnvirons;

 /**
  * Generates class files from script sources.
  *
  * since 1.5 Release 5
  * @author Igor Bukanov
  */
 
 public class ClassCompiler
 {
     /**
      * Construct ClassCompiler that uses the specified compiler environment
      * when generating classes.
      */
     public ClassCompiler(CompilerEnvirons compilerEnv)
     {
     }
 
     /**
      * Set the class name to use for main method implementation.
      * The class must have a method matching
      * <code>public static void main(Script sc, String[] args)</code>, it will be
      * called when <code>main(String[] args)</code> is called in the generated
      * class. The class name should be fully qulified name and include the
      * package name like in <code>org.foo.Bar</code>.
      */
     public void setMainMethodClass(String className)
     {
     }
 
     /**
      * Get the name of the class for main method implementation.
      * @see #setMainMethodClass(String)
      */
     public String getMainMethodClass()
     {
         return null;
     }
 
     /**
      * Get the compiler environment the compiler uses.
      */
     public CompilerEnvirons getCompilerEnv()
     {
        return null;
    }
 
     /**
      * Get the class that the generated target will extend.
      */
     public Class<?> getTargetExtends()
     {
        return null;
    }
 
     /**
      * Set the class that the generated target will extend.
      *
      * @param extendsClass the class it extends
      */
     public void setTargetExtends(Class<?> extendsClass)
     {
     }
 
     /**
      * Get the interfaces that the generated target will implement.
      */
     public Class<?>[] getTargetImplements()
     {
        return null;
    }
 
     /**
      * Set the interfaces that the generated target will implement.
      *
      * @param implementsClasses an array of Class objects, one for each
      *                          interface the target will extend
      */
     public void setTargetImplements(Class<?>[] implementsClasses)
     {
     }
  
     /**
      * Compile JavaScript source into one or more Java class files.
      * The first compiled class will have name mainClassName.
      * If the results of {@link #getTargetExtends()} or
      * {@link #getTargetImplements()} are not null, then the first compiled
      * class will extend the specified super class and implement
      * specified interfaces.
      *
      * @return array where elements with even indexes specifies class name
      *         and the following odd index gives class file body as byte[]
      *         array. The initial element of the array always holds
      *         mainClassName and array[1] holds its byte code.
      */
     public Object[] compileToClassFiles(String source,
                                         String sourceLocation,
                                         int lineno,
                                         String mainClassName)
     {
        return null;
     }
 }