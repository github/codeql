// Generated automatically from org.apache.hive.hcatalog.templeton.ExecService for testing purposes

package org.apache.hive.hcatalog.templeton;

import java.util.List;
import java.util.Map;
import org.apache.hive.hcatalog.templeton.ExecBean;

public interface ExecService
{
    ExecBean run(String p0, List<String> p1, Map<String, String> p2);
    ExecBean runUnlimited(String p0, List<String> p1, Map<String, String> p2);
}
