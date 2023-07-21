// Generated automatically from javafx.scene.image.PixelFormat for testing purposes

package javafx.scene.image;

import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import javafx.scene.image.WritablePixelFormat;

abstract public class PixelFormat<T extends Buffer>
{
    protected PixelFormat() {}
    public PixelFormat.Type getType(){ return null; }
    public abstract boolean isPremultiplied();
    public abstract boolean isWritable();
    public abstract int getArgb(T p0, int p1, int p2, int p3);
    public static PixelFormat<ByteBuffer> createByteIndexedInstance(int[] p0){ return null; }
    public static PixelFormat<ByteBuffer> createByteIndexedPremultipliedInstance(int[] p0){ return null; }
    public static PixelFormat<ByteBuffer> getByteRgbInstance(){ return null; }
    public static WritablePixelFormat<ByteBuffer> getByteBgraInstance(){ return null; }
    public static WritablePixelFormat<ByteBuffer> getByteBgraPreInstance(){ return null; }
    public static WritablePixelFormat<IntBuffer> getIntArgbInstance(){ return null; }
    public static WritablePixelFormat<IntBuffer> getIntArgbPreInstance(){ return null; }
    static public enum Type
    {
        BYTE_BGRA, BYTE_BGRA_PRE, BYTE_INDEXED, BYTE_RGB, INT_ARGB, INT_ARGB_PRE;
        private Type() {}
    }
}
