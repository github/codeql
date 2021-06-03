// Copyright (c) Corporation for National Research Initiatives
package org.python.core;
import java.io.*;

/**
 * A wrapper for all python exception. Note that the well-known python exceptions are <b>not</b>
 * subclasses of PyException. Instead the python exception class is stored in the <code>type</code>
 * field and value or class instance is stored in the <code>value</code> field.
 */
public class PyException extends RuntimeException
{
}
