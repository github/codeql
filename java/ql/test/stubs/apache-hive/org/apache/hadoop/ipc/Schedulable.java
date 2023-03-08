// Generated automatically from org.apache.hadoop.ipc.Schedulable for testing purposes

package org.apache.hadoop.ipc;

import org.apache.hadoop.security.UserGroupInformation;

public interface Schedulable
{
    UserGroupInformation getUserGroupInformation();
    int getPriorityLevel();
}
