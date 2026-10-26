// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.io.OutputDecorator for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core.io;

import java.io.OutputStream;
import java.io.Serializable;
import java.io.Writer;
import org.apache.htrace.shaded.fasterxml.jackson.core.io.IOContext;

abstract public class OutputDecorator implements Serializable
{
    public OutputDecorator(){}
    public abstract OutputStream decorate(IOContext p0, OutputStream p1);
    public abstract Writer decorate(IOContext p0, Writer p1);
}
