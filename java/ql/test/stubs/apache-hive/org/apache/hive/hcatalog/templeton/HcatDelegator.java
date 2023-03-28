// Generated automatically from org.apache.hive.hcatalog.templeton.HcatDelegator for testing purposes

package org.apache.hive.hcatalog.templeton;

import javax.ws.rs.core.Response;
import org.apache.hive.hcatalog.templeton.AppConfig;
import org.apache.hive.hcatalog.templeton.ColumnDesc;
import org.apache.hive.hcatalog.templeton.DatabaseDesc;
import org.apache.hive.hcatalog.templeton.ExecBean;
import org.apache.hive.hcatalog.templeton.ExecService;
import org.apache.hive.hcatalog.templeton.LauncherDelegator;
import org.apache.hive.hcatalog.templeton.PartitionDesc;
import org.apache.hive.hcatalog.templeton.TableDesc;
import org.apache.hive.hcatalog.templeton.TableLikeDesc;
import org.apache.hive.hcatalog.templeton.TablePropertyDesc;

public class HcatDelegator extends LauncherDelegator
{
    protected HcatDelegator() {}
    public ExecBean run(String p0, String p1, boolean p2, String p3, String p4){ return null; }
    public HcatDelegator(AppConfig p0, ExecService p1){}
    public Response addOneColumn(String p0, String p1, String p2, ColumnDesc p3){ return null; }
    public Response addOnePartition(String p0, String p1, String p2, PartitionDesc p3){ return null; }
    public Response addOneTableProperty(String p0, String p1, String p2, TablePropertyDesc p3){ return null; }
    public Response createDatabase(String p0, DatabaseDesc p1){ return null; }
    public Response createTable(String p0, String p1, TableDesc p2){ return null; }
    public Response createTableLike(String p0, String p1, TableLikeDesc p2){ return null; }
    public Response descDatabase(String p0, String p1, boolean p2){ return null; }
    public Response descExtendedTable(String p0, String p1, String p2){ return null; }
    public Response descOneColumn(String p0, String p1, String p2, String p3){ return null; }
    public Response descOnePartition(String p0, String p1, String p2, String p3){ return null; }
    public Response descTable(String p0, String p1, String p2, boolean p3){ return null; }
    public Response descTableProperty(String p0, String p1, String p2, String p3){ return null; }
    public Response dropDatabase(String p0, String p1, boolean p2, String p3, String p4, String p5){ return null; }
    public Response dropPartition(String p0, String p1, String p2, String p3, boolean p4, String p5, String p6){ return null; }
    public Response dropTable(String p0, String p1, String p2, boolean p3, String p4, String p5){ return null; }
    public Response listColumns(String p0, String p1, String p2){ return null; }
    public Response listDatabases(String p0, String p1){ return null; }
    public Response listPartitions(String p0, String p1, String p2){ return null; }
    public Response listTableProperties(String p0, String p1, String p2){ return null; }
    public Response listTables(String p0, String p1, String p2){ return null; }
    public Response renameTable(String p0, String p1, String p2, String p3, String p4, String p5){ return null; }
}
