// Generated automatically from net.lingala.zip4j.progress.ProgressMonitor for testing purposes

package net.lingala.zip4j.progress;


public class ProgressMonitor
{
    public Exception getException(){ return null; }
    public ProgressMonitor(){}
    public ProgressMonitor.Result getResult(){ return null; }
    public ProgressMonitor.State getState(){ return null; }
    public ProgressMonitor.Task getCurrentTask(){ return null; }
    public String getFileName(){ return null; }
    public boolean isCancelAllTasks(){ return false; }
    public boolean isPause(){ return false; }
    public int getPercentDone(){ return 0; }
    public long getTotalWork(){ return 0; }
    public long getWorkCompleted(){ return 0; }
    public void endProgressMonitor(){}
    public void endProgressMonitor(Exception p0){}
    public void fullReset(){}
    public void setCancelAllTasks(boolean p0){}
    public void setCurrentTask(ProgressMonitor.Task p0){}
    public void setException(Exception p0){}
    public void setFileName(String p0){}
    public void setPause(boolean p0){}
    public void setPercentDone(int p0){}
    public void setResult(ProgressMonitor.Result p0){}
    public void setState(ProgressMonitor.State p0){}
    public void setTotalWork(long p0){}
    public void updateWorkCompleted(long p0){}
    static public enum Result
    {
        CANCELLED, ERROR, SUCCESS, WORK_IN_PROGRESS;
        private Result() {}
    }
    static public enum State
    {
        BUSY, READY;
        private State() {}
    }
    static public enum Task
    {
        ADD_ENTRY, CALCULATE_CRC, EXTRACT_ENTRY, MERGE_ZIP_FILES, NONE, REMOVE_ENTRY, RENAME_FILE, SET_COMMENT;
        private Task() {}
    }
}
