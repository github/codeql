// Generated automatically from android.os.CancellationSignal for testing purposes

package android.os;


public class CancellationSignal
{
    public CancellationSignal(){}
    public boolean isCanceled(){ return false; }
    public void cancel(){}
    public void setOnCancelListener(CancellationSignal.OnCancelListener p0){}
    public void throwIfCanceled(){}
    static public interface OnCancelListener
    {
        void onCancel();
    }
}
