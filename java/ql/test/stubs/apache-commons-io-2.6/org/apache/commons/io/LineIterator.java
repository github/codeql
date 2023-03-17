// Generated automatically from org.apache.commons.io.LineIterator for testing purposes

package org.apache.commons.io;

import java.io.Closeable;
import java.io.Reader;
import java.util.Iterator;

public class LineIterator implements Closeable, Iterator<String>
{
    protected LineIterator() {}
    protected boolean isValidLine(String p0){ return false; }
    public LineIterator(Reader p0){}
    public String next(){ return null; }
    public String nextLine(){ return null; }
    public boolean hasNext(){ return false; }
    public static void closeQuietly(LineIterator p0){}
    public void close(){}
    public void remove(){}
}
