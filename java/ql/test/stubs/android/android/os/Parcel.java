// Generated automatically from android.os.Parcel for testing purposes

package android.os;

import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.ParcelFileDescriptor;
import android.os.Parcelable;
import android.os.PersistableBundle;
import android.util.ArrayMap;
import android.util.Size;
import android.util.SizeF;
import android.util.SparseArray;
import android.util.SparseBooleanArray;
import java.io.FileDescriptor;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Parcel
{
    protected Parcel() {}
    protected void finalize(){}
    public <T extends Parcelable> ArrayMap<String, T> createTypedArrayMap(Parcelable.Creator<T> p0){ return null; }
    public <T extends Parcelable> List<T> readParcelableList(List<T> p0, ClassLoader p1){ return null; }
    public <T extends Parcelable> SparseArray<T> createTypedSparseArray(Parcelable.Creator<T> p0){ return null; }
    public <T extends Parcelable> T readParcelable(ClassLoader p0){ return null; }
    public <T extends Parcelable> void writeParcelableArray(T[] p0, int p1){}
    public <T extends Parcelable> void writeParcelableList(List<T> p0, int p1){}
    public <T extends Parcelable> void writeTypedArray(T[] p0, int p1){}
    public <T extends Parcelable> void writeTypedArrayMap(ArrayMap<String, T> p0, int p1){}
    public <T extends Parcelable> void writeTypedList(List<T> p0){}
    public <T extends Parcelable> void writeTypedObject(T p0, int p1){}
    public <T extends Parcelable> void writeTypedSparseArray(SparseArray<T> p0, int p1){}
    public <T> ArrayList<T> createTypedArrayList(Parcelable.Creator<T> p0){ return null; }
    public <T> SparseArray<T> readSparseArray(ClassLoader p0){ return null; }
    public <T> T readTypedObject(Parcelable.Creator<T> p0){ return null; }
    public <T> T[] createTypedArray(Parcelable.Creator<T> p0){ return null; }
    public <T> void readTypedArray(T[] p0, Parcelable.Creator<T> p1){}
    public <T> void readTypedList(List<T> p0, Parcelable.Creator<T> p1){}
    public <T> void writeSparseArray(SparseArray<T> p0){}
    public ArrayList readArrayList(ClassLoader p0){ return null; }
    public ArrayList<IBinder> createBinderArrayList(){ return null; }
    public ArrayList<String> createStringArrayList(){ return null; }
    public Bundle readBundle(){ return null; }
    public Bundle readBundle(ClassLoader p0){ return null; }
    public HashMap readHashMap(ClassLoader p0){ return null; }
    public IBinder readStrongBinder(){ return null; }
    public IBinder[] createBinderArray(){ return null; }
    public Object readValue(ClassLoader p0){ return null; }
    public Object[] readArray(ClassLoader p0){ return null; }
    public ParcelFileDescriptor readFileDescriptor(){ return null; }
    public Parcelable.Creator<? extends Object> readParcelableCreator(ClassLoader p0){ return null; }
    public Parcelable[] readParcelableArray(ClassLoader p0){ return null; }
    public PersistableBundle readPersistableBundle(){ return null; }
    public PersistableBundle readPersistableBundle(ClassLoader p0){ return null; }
    public Serializable readSerializable(){ return null; }
    public Size readSize(){ return null; }
    public SizeF readSizeF(){ return null; }
    public SparseBooleanArray readSparseBooleanArray(){ return null; }
    public String readString(){ return null; }
    public String[] createStringArray(){ return null; }
    public boolean hasFileDescriptors(){ return false; }
    public boolean readBoolean(){ return false; }
    public boolean[] createBooleanArray(){ return null; }
    public byte readByte(){ return 0; }
    public byte[] createByteArray(){ return null; }
    public byte[] marshall(){ return null; }
    public char[] createCharArray(){ return null; }
    public double readDouble(){ return 0; }
    public double[] createDoubleArray(){ return null; }
    public float readFloat(){ return 0; }
    public float[] createFloatArray(){ return null; }
    public int dataAvail(){ return 0; }
    public int dataCapacity(){ return 0; }
    public int dataPosition(){ return 0; }
    public int dataSize(){ return 0; }
    public int readInt(){ return 0; }
    public int[] createIntArray(){ return null; }
    public long readLong(){ return 0; }
    public long[] createLongArray(){ return null; }
    public static Parcel obtain(){ return null; }
    public static Parcelable.Creator<String> STRING_CREATOR = null;
    public void appendFrom(Parcel p0, int p1, int p2){}
    public void enforceInterface(String p0){}
    public void readBinderArray(IBinder[] p0){}
    public void readBinderList(List<IBinder> p0){}
    public void readBooleanArray(boolean[] p0){}
    public void readByteArray(byte[] p0){}
    public void readCharArray(char[] p0){}
    public void readDoubleArray(double[] p0){}
    public void readException(){}
    public void readException(int p0, String p1){}
    public void readFloatArray(float[] p0){}
    public void readIntArray(int[] p0){}
    public void readList(List p0, ClassLoader p1){}
    public void readLongArray(long[] p0){}
    public void readMap(Map p0, ClassLoader p1){}
    public void readStringArray(String[] p0){}
    public void readStringList(List<String> p0){}
    public void recycle(){}
    public void setDataCapacity(int p0){}
    public void setDataPosition(int p0){}
    public void setDataSize(int p0){}
    public void unmarshall(byte[] p0, int p1, int p2){}
    public void writeArray(Object[] p0){}
    public void writeBinderArray(IBinder[] p0){}
    public void writeBinderList(List<IBinder> p0){}
    public void writeBoolean(boolean p0){}
    public void writeBooleanArray(boolean[] p0){}
    public void writeBundle(Bundle p0){}
    public void writeByte(byte p0){}
    public void writeByteArray(byte[] p0){}
    public void writeByteArray(byte[] p0, int p1, int p2){}
    public void writeCharArray(char[] p0){}
    public void writeDouble(double p0){}
    public void writeDoubleArray(double[] p0){}
    public void writeException(Exception p0){}
    public void writeFileDescriptor(FileDescriptor p0){}
    public void writeFloat(float p0){}
    public void writeFloatArray(float[] p0){}
    public void writeInt(int p0){}
    public void writeIntArray(int[] p0){}
    public void writeInterfaceToken(String p0){}
    public void writeList(List p0){}
    public void writeLong(long p0){}
    public void writeLongArray(long[] p0){}
    public void writeMap(Map p0){}
    public void writeNoException(){}
    public void writeParcelable(Parcelable p0, int p1){}
    public void writeParcelableCreator(Parcelable p0){}
    public void writePersistableBundle(PersistableBundle p0){}
    public void writeSerializable(Serializable p0){}
    public void writeSize(Size p0){}
    public void writeSizeF(SizeF p0){}
    public void writeSparseBooleanArray(SparseBooleanArray p0){}
    public void writeString(String p0){}
    public void writeStringArray(String[] p0){}
    public void writeStringList(List<String> p0){}
    public void writeStrongBinder(IBinder p0){}
    public void writeStrongInterface(IInterface p0){}
    public void writeValue(Object p0){}
}
