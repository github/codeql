// Generated automatically from android.os.MessageQueue for testing purposes

package android.os;

import java.io.FileDescriptor;

public class MessageQueue
{
    protected void finalize(){}
    public boolean isIdle(){ return false; }
    public void addIdleHandler(MessageQueue.IdleHandler p0){}
    public void addOnFileDescriptorEventListener(FileDescriptor p0, int p1, MessageQueue.OnFileDescriptorEventListener p2){}
    public void removeIdleHandler(MessageQueue.IdleHandler p0){}
    public void removeOnFileDescriptorEventListener(FileDescriptor p0){}
    static public interface IdleHandler
    {
        boolean queueIdle();
    }
    static public interface OnFileDescriptorEventListener
    {
        int onFileDescriptorEvents(FileDescriptor p0, int p1);
        static int EVENT_ERROR = 0;
        static int EVENT_INPUT = 0;
        static int EVENT_OUTPUT = 0;
    }
}
