/**
 * This package contains a Java implementation of the
 * <a href="https://github.com/Constellation/doctrine">Doctrine AST format</a>.
 *
 * <p>
 * The root of the AST class hierarchy is {@link com.semmle.js.ast.jsdoc.JSDocElement}, which in
 * turn extends {@link com.semmle.js.ast.SourceElement}.
 * </p>
 *
 * <p>
 * Nodes accept visitors implementing interface {@link com.semmle.js.ast.jsdoc.Visitor}.
 * </p>
 */
package com.semmle.js.ast.jsdoc;