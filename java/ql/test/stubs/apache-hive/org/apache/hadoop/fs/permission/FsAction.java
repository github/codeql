// Generated automatically from org.apache.hadoop.fs.permission.FsAction for testing purposes

package org.apache.hadoop.fs.permission;


public enum FsAction
{
    ALL, EXECUTE, NONE, READ, READ_EXECUTE, READ_WRITE, WRITE, WRITE_EXECUTE;
    private FsAction() {}
    public FsAction and(FsAction p0){ return null; }
    public FsAction not(){ return null; }
    public FsAction or(FsAction p0){ return null; }
    public boolean implies(FsAction p0){ return false; }
    public final String SYMBOL = null;
    public static FsAction getFsAction(String p0){ return null; }
}
