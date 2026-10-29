// Generated automatically from android.print.PrintDocumentAdapter for testing purposes

package android.print;

import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;
import android.print.PageRange;
import android.print.PrintAttributes;
import android.print.PrintDocumentInfo;

abstract public class PrintDocumentAdapter
{
    abstract static public class LayoutResultCallback
    {
        public void onLayoutCancelled(){}
        public void onLayoutFailed(CharSequence p0){}
        public void onLayoutFinished(PrintDocumentInfo p0, boolean p1){}
    }
    abstract static public class WriteResultCallback
    {
        public void onWriteCancelled(){}
        public void onWriteFailed(CharSequence p0){}
        public void onWriteFinished(PageRange[] p0){}
    }
    public PrintDocumentAdapter(){}
    public abstract void onLayout(PrintAttributes p0, PrintAttributes p1, CancellationSignal p2, PrintDocumentAdapter.LayoutResultCallback p3, Bundle p4);
    public abstract void onWrite(PageRange[] p0, ParcelFileDescriptor p1, CancellationSignal p2, PrintDocumentAdapter.WriteResultCallback p3);
    public static String EXTRA_PRINT_PREVIEW = null;
    public void onFinish(){}
    public void onStart(){}
}
