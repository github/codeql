/**
 * Provides classes modeling PEP 249.
 * See https://www.python.org/dev/peps/pep-0249/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
import semmle.python.frameworks.internal.PEP249Impl

/**
 * A module implementing PEP 249. Extend this class for implementations.
 *
 * DEPRECATED: Extend `PEP249::PEP249ModuleApiNode` instead.
 */
abstract deprecated class PEP249Module extends DataFlow::Node { }

/**
 * DEPRECATED: Use `PEP249::PEP249ModuleApiNode` instead.
 */
deprecated class PEP249ModuleApiNode = PEP249::PEP249ModuleApiNode;

/**
 * DEPRECATED: Use `PEP249::Connection` instead.
 */
deprecated module Connection = PEP249::Connection;

/**
 * DEPRECATED: Use `PEP249::Cursor` instead.
 */
deprecated module cursor = PEP249::Cursor;

/**
 * DEPRECATED: Use `PEP249::execute` instead.
 */
deprecated predicate execute = PEP249::execute/0;

/**
 * DEPRECATED: Use `PEP249::connect` instead.
 */
deprecated predicate connect = PEP249::connect/0;
