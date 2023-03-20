// Generated automatically from javafx.scene.image.PixelWriter for testing purposes

package javafx.scene.image;

import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import javafx.scene.image.PixelFormat;
import javafx.scene.image.PixelReader;
import javafx.scene.paint.Color;

public interface PixelWriter
{
    <T extends Buffer> void setPixels(int p0, int p1, int p2, int p3, javafx.scene.image.PixelFormat<T> p4, T p5, int p6);
    PixelFormat getPixelFormat();
    void setArgb(int p0, int p1, int p2);
    void setColor(int p0, int p1, Color p2);
    void setPixels(int p0, int p1, int p2, int p3, PixelFormat<ByteBuffer> p4, byte[] p5, int p6, int p7);
    void setPixels(int p0, int p1, int p2, int p3, PixelFormat<IntBuffer> p4, int[] p5, int p6, int p7);
    void setPixels(int p0, int p1, int p2, int p3, PixelReader p4, int p5, int p6);
}
