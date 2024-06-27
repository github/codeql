package com.github.codeql.test;

public class MyWriter extends java.io.Writer {
    @Override
    public void write(char[] cbuf, int off, int len) { // $ sinkModelCandidate=write(char[],int,int):Argument[this] positiveSinkExample=write(char[],int,int):Argument[0](file-content-store) sourceModelCandidate=write(char[],int,int):Parameter[this] sourceModelCandidate=write(char[],int,int):Parameter[0]
    }

    @Override
    public void close() { // $ sinkModelCandidate=close():Argument[this] sourceModelCandidate=close():Parameter[this]
    }

    @Override
    public void flush() { // $ sinkModelCandidate=flush():Argument[this] sourceModelCandidate=flush():Parameter[this]
    }
}
