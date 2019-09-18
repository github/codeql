package com.semmle.js.ast.jsx;

import com.semmle.js.ast.INode;

public interface IJSXName extends INode {
  public String getQualifiedName();
}
