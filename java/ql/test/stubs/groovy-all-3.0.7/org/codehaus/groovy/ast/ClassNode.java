/*
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for additional information regarding
 * copyright ownership. The ASF licenses this file to you under the Apache License, Version 2.0 (the
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
package org.codehaus.groovy.ast;

import java.util.List;
import java.util.Set;

public class ClassNode {

  public ClassNode redirect() {
    return null;
  }

  public boolean isRedirectNode() {
    return false;
  }

  public void setRedirect(ClassNode node) {}

  public ClassNode makeArray() {
    return null;
  }

  public boolean isPrimaryClassNode() {
    return false;
  }

  public ClassNode(Class<?> c) {}


  public boolean isSyntheticPublic() {
    return false;
  }

  public void setSyntheticPublic(boolean syntheticPublic) {}

  public ClassNode(String name, int modifiers, ClassNode superClass) {}


  public void setSuperClass(ClassNode superClass) {}

  public ClassNode[] getInterfaces() {
    return null;
  }

  public void setInterfaces(ClassNode[] interfaces) {}

  public Set<ClassNode> getAllInterfaces() {
    return null;
  }

  public String getName() {
    return null;
  }

  public String getUnresolvedName() {
    return null;
  }

  public String setName(String name) {
    return null;
  }

  public int getModifiers() {
    return 0;
  }

  public void setModifiers(int modifiers) {}

  public boolean hasProperty(String name) {
    return false;
  }

  public void addInterface(ClassNode type) {}

  public boolean equals(Object that) {
    return false;
  }

  public int hashCode() {
    return 0;
  }


  public ClassNode getOuterClass() {
    return null;
  }

  public List<ClassNode> getOuterClasses() {
    return null;
  }



  public boolean isDerivedFrom(ClassNode type) {
    return false;
  }

  public boolean isDerivedFromGroovyObject() {
    return false;
  }

  public boolean implementsAnyInterfaces(ClassNode... classNodes) {
    return false;
  }

  public boolean implementsInterface(ClassNode classNode) {
    return false;
  }

  public boolean declaresAnyInterfaces(ClassNode... classNodes) {
    return false;
  }

  public boolean declaresInterface(ClassNode classNode) {
    return false;
  }

  public ClassNode getSuperClass() {
    return null;
  }

  public ClassNode getUnresolvedSuperClass() {
    return null;
  }

  public ClassNode getUnresolvedSuperClass(boolean useRedirect) {
    return null;
  }

  public void setUnresolvedSuperClass(ClassNode superClass) {}

  public ClassNode[] getUnresolvedInterfaces() {
    return null;
  }

  public ClassNode[] getUnresolvedInterfaces(boolean useRedirect) {
    return null;
  }



  public String getPackageName() {
    return null;
  }

  public String getNameWithoutPackage() {
    return null;
  }


  public boolean isStaticClass() {
    return false;
  }

  public void setStaticClass(boolean staticClass) {}

  public boolean isScriptBody() {
    return false;
  }

  public void setScriptBody(boolean scriptBody) {}

  public boolean isScript() {
    return false;
  }

  public void setScript(boolean script) {}

  public String toString() {
    return null;
  }

  public String toString(boolean showRedirect) {
    return null;
  }

  public boolean isInterface() {
    return false;
  }

  public boolean isAbstract() {
    return false;
  }

  public boolean isResolved() {
    return false;
  }

  public boolean isArray() {
    return false;
  }

  public ClassNode getComponentType() {
    return null;
  }

  public Class getTypeClass() {
    return null;
  }

  public boolean hasPackageName() {
    return false;
  }

  public void setAnnotated(boolean annotated) {}

  public boolean isAnnotated() {
    return false;
  }

  public void setGenericsPlaceHolder(boolean placeholder) {}

  public boolean isGenericsPlaceHolder() {
    return false;
  }

  public boolean isUsingGenerics() {
    return false;
  }

  public void setUsingGenerics(boolean usesGenerics) {}

  public ClassNode getPlainNodeReference() {
    return null;
  }

  public boolean isAnnotationDefinition() {
    return false;
  }

  public void renameField(String oldName, String newName) {}

  public void removeField(String oldName) {}

  public boolean isEnum() {
    return false;
  }

}
