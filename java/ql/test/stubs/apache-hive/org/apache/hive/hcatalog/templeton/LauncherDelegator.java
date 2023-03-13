// Generated automatically from org.apache.hive.hcatalog.templeton.LauncherDelegator for testing purposes

package org.apache.hive.hcatalog.templeton;

import java.util.List;
import java.util.Map;
import org.apache.hive.hcatalog.templeton.AppConfig;
import org.apache.hive.hcatalog.templeton.EnqueueBean;
import org.apache.hive.hcatalog.templeton.TempletonDelegator;
import org.apache.hive.hcatalog.templeton.tool.TempletonControllerJob;

public class LauncherDelegator extends TempletonDelegator
{
    protected LauncherDelegator() {}
    protected String runAs = null;
    protected TempletonControllerJob getTempletonController(){ return null; }
    protected int runTempletonControllerJob(TempletonControllerJob p0, List<String> p1){ return 0; }
    protected void killJob(String p0, String p1){}
    public EnqueueBean enqueueController(String p0, Map<String, Object> p1, String p2, List<String> p3){ return null; }
    public EnqueueBean enqueueJob(String p0, Map<String, Object> p1, String p2, List<String> p3, TempletonControllerJob p4){ return null; }
    public LauncherDelegator(AppConfig p0){}
    public List<String> makeLauncherArgs(AppConfig p0, String p1, String p2, List<String> p3, boolean p4, Boolean p5, LauncherDelegator.JobType p6){ return null; }
    public static String makeOverrideClasspath(AppConfig p0){ return null; }
    public static void addCacheFiles(List<String> p0, AppConfig p1){}
    public static void addDef(List<String> p0, String p1, String p2){}
    public void registerJob(String p0, String p1, String p2, Map<String, Object> p3){}
    static public enum JobType
    {
        HIVE, JAR, PIG, SQOOP, STREAMING;
        private JobType() {}
    }
}
