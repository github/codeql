/**
 * This package contains a Java implementation of the <a
 * href="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Parser_API">SpiderMonkey
 * AST format</a>.
 *
 * <p>SpiderMonkey AST node interfaces are represented by Java classes and interfaces with the same
 * name, plus a few additional abstract classes to improve code reuse. Union types are represented
 * by additional interfaces.
 *
 * <p>The root of the AST class hierarchy is {@link com.semmle.js.ast.Node}, which in turn
 * implements interface {@link com.semmle.js.ast.INode}. Interfaces representing union types also
 * extend that interface.
 *
 * <p>Every node has a source location ({@link com.semmle.js.ast.SourceLocation}), comprising a
 * start and an end position ({@link com.semmle.js.ast.Position}). Since other source elements
 * besides nodes also have source locations, this association is kept track of by {@link
 * com.semmle.js.ast.SourceElement}, the super class of {@link com.semmle.js.ast.Node}.
 *
 * <p>Nodes accept visitors implementing interface {@link com.semmle.js.ast.Visitor}. A default
 * visitor implementation that provides catch-all visit methods for groups of AST node classes is
 * also provided ({@link com.semmle.js.ast.DefaultVisitor}).
 */
package com.semmle.js.ast;
