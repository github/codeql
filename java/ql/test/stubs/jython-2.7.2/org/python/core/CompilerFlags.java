// At some future point this will also be extended - in conjunction with
// Py#compileFlags - to add
// support for a compiler factory that user code can choose in place of the
// normal compiler.
// (Perhaps a better name might have been "CompilerOptions".)

package org.python.core;

import java.io.Serializable;

public class CompilerFlags implements Serializable {
    public CompilerFlags() {
    }

    public CompilerFlags(int co_flags) {
    }
}
