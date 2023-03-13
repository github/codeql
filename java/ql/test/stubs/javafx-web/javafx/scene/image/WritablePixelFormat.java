// Generated automatically from javafx.scene.image.WritablePixelFormat for testing purposes

package javafx.scene.image;

import java.nio.Buffer;
import javafx.scene.image.PixelFormat;

abstract public class WritablePixelFormat<T extends Buffer> extends javafx.scene.image.PixelFormat<T>
{
    protected WritablePixelFormat() {}
    public abstract void setArgb(T p0, int p1, int p2, int p3, int p4);
    public boolean isWritable(){ return false; }
}
