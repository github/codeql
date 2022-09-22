// Generated automatically from com.fasterxml.jackson.core.io.InputDecorator for testing purposes

package com.fasterxml.jackson.core.io;

import com.fasterxml.jackson.core.io.IOContext;
import java.io.InputStream;
import java.io.Reader;
import java.io.Serializable;

abstract public class InputDecorator implements Serializable
{
    public InputDecorator(){}
    public abstract InputStream decorate(IOContext p0, InputStream p1);
    public abstract InputStream decorate(IOContext p0, byte[] p1, int p2, int p3);
    public abstract Reader decorate(IOContext p0, Reader p1);
}
