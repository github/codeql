// Generated automatically from com.fasterxml.jackson.core.io.OutputDecorator for testing purposes

package com.fasterxml.jackson.core.io;

import com.fasterxml.jackson.core.io.IOContext;
import java.io.OutputStream;
import java.io.Serializable;
import java.io.Writer;

abstract public class OutputDecorator implements Serializable
{
    public OutputDecorator(){}
    public abstract OutputStream decorate(IOContext p0, OutputStream p1);
    public abstract Writer decorate(IOContext p0, Writer p1);
}
