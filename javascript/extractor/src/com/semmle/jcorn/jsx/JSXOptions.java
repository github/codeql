package com.semmle.jcorn.jsx;

import com.semmle.jcorn.Options;

public class JSXOptions extends Options {
  public boolean allowNamespacedObjects = true, allowNamespaces = true;

  public JSXOptions() {}

  public JSXOptions(Options options) {
    super(options);
  }

  public JSXOptions allowNamespacedObjects(boolean allowNamespacedObjects) {
    this.allowNamespacedObjects = allowNamespacedObjects;
    return this;
  }

  public JSXOptions allowNamespaces(boolean allowNamespaces) {
    this.allowNamespaces = allowNamespaces;
    return this;
  }
}
