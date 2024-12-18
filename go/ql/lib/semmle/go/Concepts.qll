/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

import go
import semmle.go.dataflow.FunctionInputsAndOutputs
import semmle.go.concepts.HTTP
import semmle.go.concepts.GeneratedFile

/**
 * A data-flow node that executes an operating system command,
 * for instance by spawning a new process.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SystemCommandExecution::Range` instead.
 */
class SystemCommandExecution extends DataFlow::Node instanceof SystemCommandExecution::Range {
  /** Gets the argument that specifies the command to be executed. */
  DataFlow::Node getCommandName() { result = super.getCommandName() }

  /** Holds if this node is sanitized whenever it follows `--` in an argument list. */
  predicate doubleDashIsSanitizing() { super.doubleDashIsSanitizing() }
}

/** Provides a class for modeling new system-command execution APIs. */
module SystemCommandExecution {
  /**
   * A data-flow node that executes an operating system command,
   * for instance by spawning a new process.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SystemCommandExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the command to be executed. */
    abstract DataFlow::Node getCommandName();

    /** Holds if this node is sanitized whenever it follows `--` in an argument list. */
    predicate doubleDashIsSanitizing() { none() }
  }
}

/**
 * An instantiation of a template; that is, a call which fills out a template with data.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `TemplateInstantiation::Range` instead.
 */
class TemplateInstantiation extends DataFlow::Node instanceof TemplateInstantiation::Range {
  /**
   * Gets the argument to this template instantiation that is the template being
   * instantiated.
   */
  DataFlow::Node getTemplateArgument() { result = super.getTemplateArgument() }

  /**
   * Gets an argument to this template instantiation that is data being inserted
   * into the template.
   */
  DataFlow::Node getADataArgument() { result = super.getADataArgument() }
}

/** Provides a class for modeling new template-instantiation APIs. */
module TemplateInstantiation {
  /**
   * An instantiation of a template; that is, a call which fills out a template with data.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `TemplateInstantiation` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument to this template instantiation that is the template being
     * instantiated.
     */
    abstract DataFlow::Node getTemplateArgument();

    /**
     * Gets an argument to this template instantiation that is data being inserted
     * into the template.
     */
    abstract DataFlow::Node getADataArgument();
  }
}

/**
 * A data-flow node that performs a file system access, including reading and writing data,
 * creating and deleting files and folders, checking and updating permissions, and so on.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `FileSystemAccess::Range` instead.
 */
class FileSystemAccess extends DataFlow::Node instanceof FileSystemAccess::Range {
  /** Gets an argument to this file system access that is interpreted as a path. */
  DataFlow::Node getAPathArgument() { result = super.getAPathArgument() }
}

/** Provides a class for modeling new file-system access APIs. */
module FileSystemAccess {
  /**
   * A data-flow node that performs a file system access, including reading and writing data,
   * creating and deleting files and folders, checking and updating permissions, and so on.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `FileSystemAccess` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets an argument to this file system access that is interpreted as a path. */
    abstract DataFlow::Node getAPathArgument();
  }
}

private class DefaultFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
  DataFlow::ArgumentNode pathArgument;

  DefaultFileSystemAccess() {
    sinkNode(pathArgument, "path-injection") and
    this = pathArgument.getCall()
  }

  override DataFlow::Node getAPathArgument() {
    result = pathArgument.getACorrespondingSyntacticArgument()
  }
}

/** A function that escapes meta-characters to prevent injection attacks. */
class EscapeFunction extends Function instanceof EscapeFunction::Range {
  /**
   * Gets the context that this function escapes for.
   *
   * Currently, this can be "js", "html", or "url".
   */
  string kind() { result = super.kind() }
}

/** Provides a class for modeling new escape-function APIs. */
module EscapeFunction {
  /**
   * A function that escapes meta-characters to prevent injection attacks.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `EscapeFunction' instead.
   */
  abstract class Range extends Function {
    /**
     * Gets the context that this function escapes for.
     *
     * Currently, this can be `js', `html', or `url'.
     */
    abstract string kind();
  }
}

/**
 * A function that escapes a string so it can be safely included in a
 * JavaScript string literal.
 */
class JsEscapeFunction extends EscapeFunction {
  JsEscapeFunction() { super.kind() = "js" }
}

/**
 * A function that escapes a string so it can be safely included in an
 * the body of an HTML element, for example, replacing `{}` in
 * `<p>{}</p>`.
 */
class HtmlEscapeFunction extends EscapeFunction {
  HtmlEscapeFunction() { super.kind() = "html" }
}

/**
 * A function that escapes a string so it can be safely included as part
 * of a URL.
 */
class UrlEscapeFunction extends EscapeFunction {
  UrlEscapeFunction() { super.kind() = "url" }
}

/**
 * A node whose value is interpreted as a part of a regular expression.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexpPattern::Range` instead.
 */
class RegexpPattern extends DataFlow::Node instanceof RegexpPattern::Range {
  /**
   * Gets the node where this pattern is parsed as a part of a regular
   * expression.
   */
  DataFlow::Node getAParse() { result = super.getAParse() }

  /**
   * Gets this regexp pattern as a string.
   */
  string getPattern() { result = super.getPattern() }

  /**
   * Gets a use of this pattern, either as itself in an argument to a function or as a compiled
   * regexp object.
   */
  DataFlow::Node getAUse() { result = super.getAUse() }
}

/** Provides a class for modeling new regular-expression APIs. */
module RegexpPattern {
  /**
   * A node whose value is interpreted as a part of a regular expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexpPattern' instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets a node where the pattern of this node is parsed as a part of
     * a regular expression.
     */
    abstract DataFlow::Node getAParse();

    /**
     * Gets this regexp pattern as a string.
     */
    abstract string getPattern();

    /**
     * Gets a use of this pattern, either as itself in an argument to a function or as a compiled
     * regexp object.
     */
    abstract DataFlow::Node getAUse();
  }
}

/**
 * A function that matches a regexp with a string or byte slice.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexpMatchFunction::Range` instead.
 */
class RegexpMatchFunction extends Function instanceof RegexpMatchFunction::Range {
  /**
   * Gets the function input that is the regexp being matched.
   */
  FunctionInput getRegexpArg() { result = super.getRegexpArg() }

  /**
   * Gets the regexp pattern that is used in the call to this function `call`.
   */
  RegexpPattern getRegexp(DataFlow::CallNode call) {
    result.getAUse() = this.getRegexpArg().getNode(call)
  }

  /**
   * Gets the function input that is the string being matched against.
   */
  FunctionInput getValue() { result = super.getValue() }

  /**
   * Gets the function output that is the Boolean result of the match function.
   */
  FunctionOutput getResult() { result = super.getResult() }
}

/** Provides a class for modeling new regular-expression matcher APIs. */
module RegexpMatchFunction {
  /**
   * A function that matches a regexp with a string or byte slice.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexpPattern' instead.
   */
  abstract class Range extends Function {
    /**
     * Gets the function input that is the regexp being matched.
     */
    abstract FunctionInput getRegexpArg();

    /**
     * Gets the function input that is the string being matched against.
     */
    abstract FunctionInput getValue();

    /**
     * Gets the Boolean result of the match function.
     */
    abstract FunctionOutput getResult();
  }
}

/**
 * A function that uses a regexp to replace parts of a string or byte slice.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexpReplaceFunction::Range` instead.
 */
class RegexpReplaceFunction extends Function instanceof RegexpReplaceFunction::Range {
  /**
   * Gets the function input that is the regexp that matches text to replace.
   */
  FunctionInput getRegexpArg() { result = super.getRegexpArg() }

  /**
   * Gets the regexp pattern that is used to match patterns to replace in the call to this function
   * `call`.
   */
  RegexpPattern getRegexp(DataFlow::CallNode call) {
    result.getAUse() = call.(DataFlow::MethodCallNode).getReceiver()
  }

  /**
   * Gets the function input corresponding to the source value, that is, the value that is having
   * its contents replaced.
   */
  FunctionInput getSource() { result = super.getSource() }

  /**
   * Gets the function output corresponding to the result, that is, the value after replacement has
   * occurred.
   */
  FunctionOutput getResult() { result = super.getResult() }
}

/** Provides a class for modeling new regular-expression replacer APIs. */
module RegexpReplaceFunction {
  /**
   * A function that uses a regexp to replace parts of a string or byte slice.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexpReplaceFunction' instead.
   */
  abstract class Range extends Function {
    /**
     * Gets the function input that is the regexp that matches text to replace.
     */
    abstract FunctionInput getRegexpArg();

    /**
     * Gets the function input corresponding to the source value, that is, the value that is having
     * its contents replaced.
     */
    abstract FunctionInput getSource();

    /**
     * Gets the function output corresponding to the result, that is, the value after replacement
     * has occurred.
     */
    abstract FunctionOutput getResult();
  }
}

/**
 * A call to a logging mechanism.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LoggerCall::Range` instead.
 */
class LoggerCall extends DataFlow::Node instanceof LoggerCall::Range {
  /** Gets a node that is a part of the logged message. */
  DataFlow::Node getAMessageComponent() { result = super.getAMessageComponent() }
}

/** Provides a class for modeling new logging APIs. */
module LoggerCall {
  /**
   * A call to a logging mechanism.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LoggerCall` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets a node that is a part of the logged message. */
    abstract DataFlow::Node getAMessageComponent();
  }
}

private class DefaultLoggerCall extends LoggerCall::Range, DataFlow::CallNode {
  DataFlow::ArgumentNode messageComponent;

  DefaultLoggerCall() {
    sinkNode(messageComponent, "log-injection") and
    this = messageComponent.getCall()
  }

  override DataFlow::Node getAMessageComponent() {
    not messageComponent instanceof DataFlow::ImplicitVarargsSlice and
    result = messageComponent
    or
    messageComponent instanceof DataFlow::ImplicitVarargsSlice and
    result = this.getAnImplicitVarargsArgument()
  }
}

/**
 * A call to an interface that looks like a logger. It is common to use a
 * locally-defined interface for logging to make it easy to changing logging
 * library.
 */
private class HeuristicLoggerCall extends LoggerCall::Range, DataFlow::CallNode {
  HeuristicLoggerCall() {
    exists(Method m, string tp, string logFunctionPrefix, string name |
      m = this.getTarget() and
      m.hasQualifiedName(_, tp, name) and
      m.getReceiverBaseType().getUnderlyingType() instanceof InterfaceType
    |
      tp.regexpMatch(".*[lL]ogger") and
      logFunctionPrefix =
        [
          "Debug", "Error", "Fatal", "Info", "Log", "Output", "Panic", "Print", "Trace", "Warn",
          "With"
        ] and
      name.matches(logFunctionPrefix + "%")
    )
  }

  override DataFlow::Node getAMessageComponent() { result = this.getASyntacticArgument() }
}

/**
 * A function that encodes data into a binary or textual format.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `MarshalingFunction::Range` instead.
 */
class MarshalingFunction extends Function instanceof MarshalingFunction::Range {
  /** Gets an input that is encoded by this function. */
  FunctionInput getAnInput() { result = super.getAnInput() }

  /** Gets the output that contains the encoded data produced by this function. */
  FunctionOutput getOutput() { result = super.getOutput() }

  /** Gets an identifier for the format this function encodes into, such as "JSON". */
  string getFormat() { result = super.getFormat() }
}

/** Provides a class for modeling new marshaling APIs. */
module MarshalingFunction {
  /**
   * A function that encodes data into a binary or textual format.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `MarshalingFunction` instead.
   */
  abstract class Range extends Function {
    /** Gets an input that is encoded by this function. */
    abstract FunctionInput getAnInput();

    /** Gets the output that contains the encoded data produced by this function. */
    abstract FunctionOutput getOutput();

    /** Gets an identifier for the format this function encodes into, such as "JSON". */
    abstract string getFormat();
  }
}

/**
 * A function that decodes data from a binary or textual format.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `UnmarshalingFunction::Range` instead.
 */
class UnmarshalingFunction extends Function instanceof UnmarshalingFunction::Range {
  /** Gets an input that is decoded by this function. */
  FunctionInput getAnInput() { result = super.getAnInput() }

  /** Gets the output that contains the decoded data produced by this function. */
  FunctionOutput getOutput() { result = super.getOutput() }

  /** Gets an identifier for the format this function decodes from, such as "JSON". */
  string getFormat() { result = super.getFormat() }
}

/** Provides a class for modeling new unmarshaling APIs. */
module UnmarshalingFunction {
  /**
   * A function that decodes data from a binary or textual format.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `UnmarshalingFunction` instead.
   */
  abstract class Range extends Function {
    /** Gets an input that is decoded by this function. */
    abstract FunctionInput getAnInput();

    /** Gets the output that contains the decoded data produced by this function. */
    abstract FunctionOutput getOutput();

    /** Gets an identifier for the format this function decodes from, such as "JSON". */
    abstract string getFormat();
  }
}
