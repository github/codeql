/**
 * Provides classes for JSch OS command injection detection
 */

import java

/** The class `com.jcraft.jsch.ChannelExec`. */
private class JSchChannelExec extends RefType {
  JSchChannelExec() { this.hasQualifiedName("com.jcraft.jsch", "ChannelExec") }
}

/** A method to set an OS Command for the execution. */
private class ChannelExecSetCommandMethod extends Method, ExecCallable {
  ChannelExecSetCommandMethod() {
    this.hasName("setCommand") and
    this.getDeclaringType() instanceof JSchChannelExec
  }

  override int getAnExecutedArgument() { result = 0 }
}
