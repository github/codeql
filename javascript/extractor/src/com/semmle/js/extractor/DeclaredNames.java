package com.semmle.js.extractor;

import java.util.LinkedHashSet;
import java.util.Set;

/** Names of variables, types, and namespaces declared in a particular scope. */
public class DeclaredNames {
  private Set<String> variableNames;
  private Set<String> typeNames;
  private Set<String> namespaceNames;

  public DeclaredNames() {
    this.variableNames = new LinkedHashSet<String>();
    this.typeNames = new LinkedHashSet<String>();
    this.namespaceNames = new LinkedHashSet<String>();
  }

  public DeclaredNames(
      Set<String> variableNames, Set<String> typeNames, Set<String> namespaceNames) {
    this.variableNames = variableNames;
    this.typeNames = typeNames;
    this.namespaceNames = namespaceNames;
  }

  public boolean isEmpty() {
    return variableNames.isEmpty() && typeNames.isEmpty() && namespaceNames.isEmpty();
  }

  public Set<String> getVariableNames() {
    return variableNames;
  }

  public Set<String> getTypeNames() {
    return typeNames;
  }

  public Set<String> getNamespaceNames() {
    return namespaceNames;
  }
}
