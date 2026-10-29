// Generated automatically from android.view.ScrollCaptureCallback for testing purposes

package android.view;

import android.graphics.Rect;
import android.os.CancellationSignal;
import android.view.ScrollCaptureSession;
import java.util.function.Consumer;

public interface ScrollCaptureCallback
{
    void onScrollCaptureEnd(Runnable p0);
    void onScrollCaptureImageRequest(ScrollCaptureSession p0, CancellationSignal p1, Rect p2, Consumer<Rect> p3);
    void onScrollCaptureSearch(CancellationSignal p0, Consumer<Rect> p1);
    void onScrollCaptureStart(ScrollCaptureSession p0, CancellationSignal p1, Runnable p2);
}
