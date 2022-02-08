// Generated automatically from android.view.contentcapture.ContentCaptureSession for testing purposes

package android.view.contentcapture;

import android.graphics.Insets;
import android.view.View;
import android.view.ViewStructure;
import android.view.autofill.AutofillId;
import android.view.contentcapture.ContentCaptureContext;
import android.view.contentcapture.ContentCaptureSessionId;

abstract public class ContentCaptureSession implements AutoCloseable
{
    public AutofillId newAutofillId(AutofillId p0, long p1){ return null; }
    public String toString(){ return null; }
    public final ContentCaptureContext getContentCaptureContext(){ return null; }
    public final ContentCaptureSession createContentCaptureSession(ContentCaptureContext p0){ return null; }
    public final ContentCaptureSessionId getContentCaptureSessionId(){ return null; }
    public final ViewStructure newViewStructure(View p0){ return null; }
    public final ViewStructure newVirtualViewStructure(AutofillId p0, long p1){ return null; }
    public final void destroy(){}
    public final void notifySessionPaused(){}
    public final void notifySessionResumed(){}
    public final void notifyViewAppeared(ViewStructure p0){}
    public final void notifyViewDisappeared(AutofillId p0){}
    public final void notifyViewInsetsChanged(Insets p0){}
    public final void notifyViewTextChanged(AutofillId p0, CharSequence p1){}
    public final void notifyViewsDisappeared(AutofillId p0, long[] p1){}
    public final void setContentCaptureContext(ContentCaptureContext p0){}
    public void close(){}
}
