// Generated automatically from org.apache.hive.hcatalog.templeton.AppConfig for testing purposes

package org.apache.hive.hcatalog.templeton;

import java.util.Collection;
import org.apache.hadoop.conf.Configuration;

public class AppConfig extends Configuration
{
    public AppConfig(){}
    public AppConfig.JobsListOrder getListJobsOrder(){ return null; }
    public Collection<String> hiveProps(){ return null; }
    public String amMemoryMb(){ return null; }
    public String clusterHadoop(){ return null; }
    public String clusterHcat(){ return null; }
    public String clusterPython(){ return null; }
    public String controllerAMChildOpts(){ return null; }
    public String controllerMRChildOpts(){ return null; }
    public String enableJobReconnectDefault(){ return null; }
    public String getHadoopConfDir(){ return null; }
    public String hadoopQueueName(){ return null; }
    public String hiveArchive(){ return null; }
    public String hivePath(){ return null; }
    public String jettyConfiguration(){ return null; }
    public String kerberosKeytab(){ return null; }
    public String kerberosPrincipal(){ return null; }
    public String kerberosSecret(){ return null; }
    public String libJars(){ return null; }
    public String mapperMemoryMb(){ return null; }
    public String overrideJarsString(){ return null; }
    public String pigArchive(){ return null; }
    public String pigPath(){ return null; }
    public String sqoopArchive(){ return null; }
    public String sqoopHome(){ return null; }
    public String sqoopPath(){ return null; }
    public String streamingJar(){ return null; }
    public String zkHosts(){ return null; }
    public String[] overrideJars(){ return null; }
    public int zkSessionTimeout(){ return 0; }
    public long zkCleanupInterval(){ return 0; }
    public long zkMaxAge(){ return 0; }
    public static String CALLBACK_INTERVAL_NAME = null;
    public static String CALLBACK_RETRY_NAME = null;
    public static String ENABLE_JOB_RECONNECT_DEFAULT = null;
    public static String EXEC_ENCODING_NAME = null;
    public static String EXEC_ENVS_NAME = null;
    public static String EXEC_MAX_BYTES_NAME = null;
    public static String EXEC_MAX_PROCS_NAME = null;
    public static String EXEC_TIMEOUT_NAME = null;
    public static String FRAME_OPTIONS_FILETER = null;
    public static String HADOOP_CHILD_JAVA_OPTS = null;
    public static String HADOOP_CONF_DIR = null;
    public static String HADOOP_END_INTERVAL_NAME = null;
    public static String HADOOP_END_RETRY_NAME = null;
    public static String HADOOP_END_URL_NAME = null;
    public static String HADOOP_MAP_MEMORY_MB = null;
    public static String HADOOP_MR_AM_JAVA_OPTS = null;
    public static String HADOOP_MR_AM_MEMORY_MB = null;
    public static String HADOOP_NAME = null;
    public static String HADOOP_QUEUE_NAME = null;
    public static String HADOOP_SPECULATIVE_NAME = null;
    public static String HCAT_HOME_PATH = null;
    public static String HCAT_NAME = null;
    public static String HIVE_ARCHIVE_NAME = null;
    public static String HIVE_EXTRA_FILES = null;
    public static String HIVE_HOME_PATH = null;
    public static String HIVE_PATH_NAME = null;
    public static String HIVE_PROPS_NAME = null;
    public static String JETTY_CONFIGURATION = null;
    public static String JOB_LIST_MAX_THREADS = null;
    public static String JOB_LIST_TIMEOUT = null;
    public static String JOB_STATUS_MAX_THREADS = null;
    public static String JOB_STATUS_TIMEOUT = null;
    public static String JOB_SUBMIT_MAX_THREADS = null;
    public static String JOB_SUBMIT_TIMEOUT = null;
    public static String JOB_TIMEOUT_TASK_RETRY_COUNT = null;
    public static String JOB_TIMEOUT_TASK_RETRY_INTERVAL = null;
    public static String KERBEROS_KEYTAB = null;
    public static String KERBEROS_PRINCIPAL = null;
    public static String KERBEROS_SECRET = null;
    public static String LIB_JARS_NAME = null;
    public static String MAPPER_MEMORY_MB = null;
    public static String MR_AM_MEMORY_MB = null;
    public static String OVERRIDE_JARS_ENABLED = null;
    public static String OVERRIDE_JARS_NAME = null;
    public static String PIG_ARCHIVE_NAME = null;
    public static String PIG_PATH_NAME = null;
    public static String PORT = null;
    public static String PYTHON_NAME = null;
    public static String SQOOP_ARCHIVE_NAME = null;
    public static String SQOOP_HOME_PATH = null;
    public static String SQOOP_PATH_NAME = null;
    public static String STREAMING_JAR_NAME = null;
    public static String TEMPLETON_CONTROLLER_MR_AM_JAVA_OPTS = null;
    public static String TEMPLETON_CONTROLLER_MR_CHILD_OPTS = null;
    public static String TEMPLETON_HOME_VAR = null;
    public static String TEMPLETON_JOBSLIST_ORDER = null;
    public static String UNIT_TEST_MODE = null;
    public static String WEBHCAT_CONF_DIR = null;
    public static String XSRF_FILTER_ENABLED = null;
    public static String getTempletonDir(){ return null; }
    public static String getWebhcatConfDir(){ return null; }
    public static String[] HADOOP_CONF_FILENAMES = null;
    public static String[] HADOOP_PREFIX_VARS = null;
    public static String[] TEMPLETON_CONF_FILENAMES = null;
    public void startCleanup(){}
    static public enum JobsListOrder
    {
        lexicographicalasc, lexicographicaldesc;
        private JobsListOrder() {}
    }
}
