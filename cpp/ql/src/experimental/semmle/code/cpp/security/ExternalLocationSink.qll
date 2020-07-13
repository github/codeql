import cpp
import semmle.code.cpp.security.BufferWrite
import semmle.code.cpp.security.FileWrite

/**
 * A write, to either a file or a buffer
 */
abstract class ExternalLocationSink extends DataFlow::ExprNode { }

class Temp extends ExternalLocationSink {
  Temp() {
      none()
    }
}