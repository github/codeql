// Generated automatically from org.kohsuke.stapler.framework.io.LargeText for testing purposes

package org.kohsuke.stapler.framework.io;

import java.io.File;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;
import java.nio.charset.Charset;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.framework.io.ByteBuffer;

public class LargeText
{
    protected LargeText() {}
    protected Writer createWriter(StaplerRequest p0, StaplerResponse p1, long p2){ return null; }
    protected final Charset charset = null;
    protected void setContentType(StaplerResponse p0){}
    public LargeText(ByteBuffer p0, Charset p1, boolean p2){}
    public LargeText(ByteBuffer p0, boolean p1){}
    public LargeText(File p0, Charset p1, boolean p2){}
    public LargeText(File p0, Charset p1, boolean p2, boolean p3){}
    public LargeText(File p0, boolean p1){}
    public LargeText(File p0, boolean p1, boolean p2){}
    public Reader readAll(){ return null; }
    public boolean isComplete(){ return false; }
    public long length(){ return 0; }
    public long writeLogTo(long p0, OutputStream p1){ return 0; }
    public long writeLogTo(long p0, Writer p1){ return 0; }
    public void doProgressText(StaplerRequest p0, StaplerResponse p1){}
    public void markAsComplete(){}
}
