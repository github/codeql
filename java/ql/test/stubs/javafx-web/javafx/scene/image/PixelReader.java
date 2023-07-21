// Generated automatically from javafx.scene.image.PixelReader for testing purposes

package javafx.scene.image;

import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import javafx.scene.image.PixelFormat;
import javafx.scene.image.WritablePixelFormat;
import javafx.scene.paint.Color;

public interface PixelReader
{
    <T extends Buffer> void getPixels(int p0, int p1, int p2, int p3, javafx.scene.image.WritablePixelFormat<T> p4, T p5, int p6);
    Color getColor(int p0, int p1);
    PixelFormat getPixelFormat();
    int getArgb(int p0, int p1);
    void getPixels(int p0, int p1, int p2, int p3, WritablePixelFormat<ByteBuffer> p4, byte[] p5, int p6, int p7);
    void getPixels(int p0, int p1, int p2, int p3, WritablePixelFormat<IntBuffer> p4, int[] p5, int p6, int p7);
}
