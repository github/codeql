// Generated automatically from android.os.Debug for testing purposes

package android.os;

import android.os.Parcel;
import android.os.Parcelable;
import java.io.FileDescriptor;
import java.util.Map;

public class Debug
{
    protected Debug() {}
    public static Map<String, String> getRuntimeStats(){ return null; }
    public static String getRuntimeStat(String p0){ return null; }
    public static boolean dumpService(String p0, FileDescriptor p1, String[] p2){ return false; }
    public static boolean isDebuggerConnected(){ return false; }
    public static boolean waitingForDebugger(){ return false; }
    public static int SHOW_CLASSLOADER = 0;
    public static int SHOW_FULL_DETAIL = 0;
    public static int SHOW_INITIALIZED = 0;
    public static int TRACE_COUNT_ALLOCS = 0;
    public static int getBinderDeathObjectCount(){ return 0; }
    public static int getBinderLocalObjectCount(){ return 0; }
    public static int getBinderProxyObjectCount(){ return 0; }
    public static int getBinderReceivedTransactions(){ return 0; }
    public static int getBinderSentTransactions(){ return 0; }
    public static int getGlobalAllocCount(){ return 0; }
    public static int getGlobalAllocSize(){ return 0; }
    public static int getGlobalClassInitCount(){ return 0; }
    public static int getGlobalClassInitTime(){ return 0; }
    public static int getGlobalExternalAllocCount(){ return 0; }
    public static int getGlobalExternalAllocSize(){ return 0; }
    public static int getGlobalExternalFreedCount(){ return 0; }
    public static int getGlobalExternalFreedSize(){ return 0; }
    public static int getGlobalFreedCount(){ return 0; }
    public static int getGlobalFreedSize(){ return 0; }
    public static int getGlobalGcInvocationCount(){ return 0; }
    public static int getLoadedClassCount(){ return 0; }
    public static int getThreadAllocCount(){ return 0; }
    public static int getThreadAllocSize(){ return 0; }
    public static int getThreadExternalAllocCount(){ return 0; }
    public static int getThreadExternalAllocSize(){ return 0; }
    public static int getThreadGcInvocationCount(){ return 0; }
    public static int setAllocationLimit(int p0){ return 0; }
    public static int setGlobalAllocationLimit(int p0){ return 0; }
    public static long getNativeHeapAllocatedSize(){ return 0; }
    public static long getNativeHeapFreeSize(){ return 0; }
    public static long getNativeHeapSize(){ return 0; }
    public static long getPss(){ return 0; }
    public static long threadCpuTimeNanos(){ return 0; }
    public static void attachJvmtiAgent(String p0, String p1, ClassLoader p2){}
    public static void changeDebugPort(int p0){}
    public static void dumpHprofData(String p0){}
    public static void enableEmulatorTraceOutput(){}
    public static void getMemoryInfo(Debug.MemoryInfo p0){}
    public static void printLoadedClasses(int p0){}
    public static void resetAllCounts(){}
    public static void resetGlobalAllocCount(){}
    public static void resetGlobalAllocSize(){}
    public static void resetGlobalClassInitCount(){}
    public static void resetGlobalClassInitTime(){}
    public static void resetGlobalExternalAllocCount(){}
    public static void resetGlobalExternalAllocSize(){}
    public static void resetGlobalExternalFreedCount(){}
    public static void resetGlobalExternalFreedSize(){}
    public static void resetGlobalFreedCount(){}
    public static void resetGlobalFreedSize(){}
    public static void resetGlobalGcInvocationCount(){}
    public static void resetThreadAllocCount(){}
    public static void resetThreadAllocSize(){}
    public static void resetThreadExternalAllocCount(){}
    public static void resetThreadExternalAllocSize(){}
    public static void resetThreadGcInvocationCount(){}
    public static void startAllocCounting(){}
    public static void startMethodTracing(){}
    public static void startMethodTracing(String p0){}
    public static void startMethodTracing(String p0, int p1){}
    public static void startMethodTracing(String p0, int p1, int p2){}
    public static void startMethodTracingSampling(String p0, int p1, int p2){}
    public static void startNativeTracing(){}
    public static void stopAllocCounting(){}
    public static void stopMethodTracing(){}
    public static void stopNativeTracing(){}
    public static void waitForDebugger(){}
    static public class MemoryInfo implements Parcelable
    {
        public Map<String, String> getMemoryStats(){ return null; }
        public MemoryInfo(){}
        public String getMemoryStat(String p0){ return null; }
        public int dalvikPrivateDirty = 0;
        public int dalvikPss = 0;
        public int dalvikSharedDirty = 0;
        public int describeContents(){ return 0; }
        public int getTotalPrivateClean(){ return 0; }
        public int getTotalPrivateDirty(){ return 0; }
        public int getTotalPss(){ return 0; }
        public int getTotalSharedClean(){ return 0; }
        public int getTotalSharedDirty(){ return 0; }
        public int getTotalSwappablePss(){ return 0; }
        public int nativePrivateDirty = 0;
        public int nativePss = 0;
        public int nativeSharedDirty = 0;
        public int otherPrivateDirty = 0;
        public int otherPss = 0;
        public int otherSharedDirty = 0;
        public static Parcelable.Creator<Debug.MemoryInfo> CREATOR = null;
        public void readFromParcel(Parcel p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
}
