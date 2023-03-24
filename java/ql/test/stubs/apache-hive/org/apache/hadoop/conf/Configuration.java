// Generated automatically from org.apache.hadoop.conf.Configuration for testing purposes

package org.apache.hadoop.conf;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;
import java.net.InetSocketAddress;
import java.net.URL;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;
import org.apache.hadoop.conf.StorageUnit;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Writable;

public class Configuration implements Iterable<Map.Entry<String, String>>, Writable
{
    protected Properties getProps(){ return null; }
    protected char[] getPasswordFromConfig(String p0){ return null; }
    protected char[] getPasswordFromCredentialProviders(String p0){ return null; }
    public <T extends java.lang.Enum<T>> T getEnum(String p0, T p1){ return null; }
    public <T extends java.lang.Enum<T>> void setEnum(String p0, T p1){}
    public <U> List<U> getInstances(String p0, java.lang.Class<U> p1){ return null; }
    public <U> java.lang.Class<? extends U> getClass(String p0, java.lang.Class<? extends U> p1, java.lang.Class<U> p2){ return null; }
    public Class<? extends Object> getClass(String p0, Class<? extends Object> p1){ return null; }
    public Class<? extends Object> getClassByName(String p0){ return null; }
    public Class<? extends Object> getClassByNameOrNull(String p0){ return null; }
    public Class<? extends Object>[] getClasses(String p0, Class<? extends Object>... p1){ return null; }
    public ClassLoader getClassLoader(){ return null; }
    public Collection<String> getStringCollection(String p0){ return null; }
    public Collection<String> getTrimmedStringCollection(String p0){ return null; }
    public Configuration(){}
    public Configuration(Configuration p0){}
    public Configuration(boolean p0){}
    public Configuration.IntegerRanges getRange(String p0, String p1){ return null; }
    public File getFile(String p0, String p1){ return null; }
    public InetSocketAddress getSocketAddr(String p0, String p1, String p2, int p3){ return null; }
    public InetSocketAddress getSocketAddr(String p0, String p1, int p2){ return null; }
    public InetSocketAddress updateConnectAddr(String p0, InetSocketAddress p1){ return null; }
    public InetSocketAddress updateConnectAddr(String p0, String p1, String p2, InetSocketAddress p3){ return null; }
    public InputStream getConfResourceAsInputStream(String p0){ return null; }
    public Iterator<Map.Entry<String, String>> iterator(){ return null; }
    public Map<String, String> getPropsWithPrefix(String p0){ return null; }
    public Map<String, String> getValByRegex(String p0){ return null; }
    public Path getLocalPath(String p0, String p1){ return null; }
    public Pattern getPattern(String p0, Pattern p1){ return null; }
    public Properties getAllPropertiesByTag(String p0){ return null; }
    public Properties getAllPropertiesByTags(List<String> p0){ return null; }
    public Reader getConfResourceAsReader(String p0){ return null; }
    public Set<String> getFinalParameters(){ return null; }
    public String get(String p0){ return null; }
    public String get(String p0, String p1){ return null; }
    public String getRaw(String p0){ return null; }
    public String getTrimmed(String p0){ return null; }
    public String getTrimmed(String p0, String p1){ return null; }
    public String toString(){ return null; }
    public String[] getPropertySources(String p0){ return null; }
    public String[] getStrings(String p0){ return null; }
    public String[] getStrings(String p0, String... p1){ return null; }
    public String[] getTrimmedStrings(String p0){ return null; }
    public String[] getTrimmedStrings(String p0, String... p1){ return null; }
    public URL getResource(String p0){ return null; }
    public boolean getBoolean(String p0, boolean p1){ return false; }
    public boolean isPropertyTag(String p0){ return false; }
    public boolean onlyKeyExists(String p0){ return false; }
    public char[] getPassword(String p0){ return null; }
    public double getDouble(String p0, double p1){ return 0; }
    public double getStorageSize(String p0, String p1, StorageUnit p2){ return 0; }
    public double getStorageSize(String p0, double p1, StorageUnit p2){ return 0; }
    public float getFloat(String p0, float p1){ return 0; }
    public int getInt(String p0, int p1){ return 0; }
    public int size(){ return 0; }
    public int[] getInts(String p0){ return null; }
    public long getLong(String p0, long p1){ return 0; }
    public long getLongBytes(String p0, long p1){ return 0; }
    public long getTimeDuration(String p0, String p1, TimeUnit p2){ return 0; }
    public long getTimeDuration(String p0, long p1, TimeUnit p2){ return 0; }
    public long getTimeDurationHelper(String p0, String p1, TimeUnit p2){ return 0; }
    public long[] getTimeDurations(String p0, TimeUnit p1){ return null; }
    public static boolean hasWarnedDeprecation(String p0){ return false; }
    public static boolean isDeprecated(String p0){ return false; }
    public static void addDefaultResource(String p0){}
    public static void addDeprecation(String p0, String p1){}
    public static void addDeprecation(String p0, String p1, String p2){}
    public static void addDeprecation(String p0, String[] p1){}
    public static void addDeprecation(String p0, String[] p1, String p2){}
    public static void addDeprecations(Configuration.DeprecationDelta[] p0){}
    public static void dumpConfiguration(Configuration p0, String p1, Writer p2){}
    public static void dumpConfiguration(Configuration p0, Writer p1){}
    public static void dumpDeprecatedKeys(){}
    public static void main(String[] p0){}
    public static void reloadExistingConfigurations(){}
    public static void setRestrictSystemPropertiesDefault(boolean p0){}
    public void addResource(Configuration p0){}
    public void addResource(InputStream p0){}
    public void addResource(InputStream p0, String p1){}
    public void addResource(InputStream p0, String p1, boolean p2){}
    public void addResource(InputStream p0, boolean p1){}
    public void addResource(Path p0){}
    public void addResource(Path p0, boolean p1){}
    public void addResource(String p0){}
    public void addResource(String p0, boolean p1){}
    public void addResource(URL p0){}
    public void addResource(URL p0, boolean p1){}
    public void clear(){}
    public void readFields(DataInput p0){}
    public void reloadConfiguration(){}
    public void set(String p0, String p1){}
    public void set(String p0, String p1, String p2){}
    public void setAllowNullValueProperties(boolean p0){}
    public void setBoolean(String p0, boolean p1){}
    public void setBooleanIfUnset(String p0, boolean p1){}
    public void setClass(String p0, Class<? extends Object> p1, Class<? extends Object> p2){}
    public void setClassLoader(ClassLoader p0){}
    public void setDeprecatedProperties(){}
    public void setDouble(String p0, double p1){}
    public void setFloat(String p0, float p1){}
    public void setIfUnset(String p0, String p1){}
    public void setInt(String p0, int p1){}
    public void setLong(String p0, long p1){}
    public void setPattern(String p0, Pattern p1){}
    public void setQuietMode(boolean p0){}
    public void setRestrictSystemProperties(boolean p0){}
    public void setRestrictSystemProps(boolean p0){}
    public void setSocketAddr(String p0, InetSocketAddress p1){}
    public void setStorageSize(String p0, double p1, StorageUnit p2){}
    public void setStrings(String p0, String... p1){}
    public void setTimeDuration(String p0, long p1, TimeUnit p2){}
    public void unset(String p0){}
    public void write(DataOutput p0){}
    public void writeXml(OutputStream p0){}
    public void writeXml(String p0, Writer p1){}
    public void writeXml(Writer p0){}
    static public class DeprecationDelta
    {
        protected DeprecationDelta() {}
        public DeprecationDelta(String p0, String p1){}
        public DeprecationDelta(String p0, String p1, String p2){}
        public String getCustomMessage(){ return null; }
        public String getKey(){ return null; }
        public String[] getNewKeys(){ return null; }
    }
    static public class IntegerRanges implements Iterable<Integer>
    {
        public IntegerRanges(){}
        public IntegerRanges(String p0){}
        public Iterator<Integer> iterator(){ return null; }
        public String toString(){ return null; }
        public boolean isEmpty(){ return false; }
        public boolean isIncluded(int p0){ return false; }
        public int getRangeStart(){ return 0; }
    }
}
