/**
 * This module is deprecated, and exists as a shim to support any existing code that relies on it.
 * New code should use `codeql.ruby.frameworks.Core` and `codeql.ruby.frameworks.Stdlib` instead.
 */

private import codeql.ruby.frameworks.Core as Core
private import codeql.ruby.frameworks.Stdlib as Stdlib

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class SubshellLiteralExecution = Core::SubshellLiteralExecution;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class SubshellHeredocExecution = Core::SubshellHeredocExecution;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class BasicObjectInstanceMethodCall = Core::BasicObjectInstanceMethodCall;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated predicate basicObjectInstanceMethodName = Core::basicObjectInstanceMethodName/0;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class InstanceEvalCallCodeExecution = Core::InstanceEvalCallCodeExecution;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class ObjectInstanceMethodCall = Core::ObjectInstanceMethodCall;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated predicate objectInstanceMethodName = Core::objectInstanceMethodName/0;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class KernelMethodCall = Core::KernelMethodCall;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class KernelSystemCall = Core::KernelSystemCall;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class KernelExecCall = Core::KernelExecCall;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class KernelSpawnCall = Core::KernelSpawnCall;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class EvalCallCodeExecution = Core::EvalCallCodeExecution;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated class SendCallCodeExecution = Core::SendCallCodeExecution;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated module Module = Core::Module;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Core` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated module Array = Core::Array;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Stdlib` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated module Regexp = Core::Regexp;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Stdlib` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated module Open3 = Stdlib::Open3;

/**
 * DEPRECATED: Import `codeql.ruby.frameworks.Stdlib` instead of `codeql.ruby.frameworks.StandardLibrary`.
 */
deprecated module Logger = Stdlib::Logger;
