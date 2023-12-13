/**
 * This file activates debugging mode for dataflow node printing.
 */

private import Node0ToString

private class DebugNode0ToString extends Node0ToString {
  final override predicate isDebugMode() { any() }
}
