// Generated automatically from org.apache.hadoop.security.authorize.ServiceAuthorizationManager for testing purposes

package org.apache.hadoop.security.authorize;

import java.net.InetAddress;
import java.util.Set;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hadoop.security.authorize.AccessControlList;
import org.apache.hadoop.security.authorize.PolicyProvider;
import org.apache.hadoop.util.MachineList;
import org.slf4j.Logger;

public class ServiceAuthorizationManager
{
    public AccessControlList getProtocolsAcls(Class<? extends Object> p0){ return null; }
    public AccessControlList getProtocolsBlockedAcls(Class<? extends Object> p0){ return null; }
    public MachineList getProtocolsBlockedMachineList(Class<? extends Object> p0){ return null; }
    public MachineList getProtocolsMachineList(Class<? extends Object> p0){ return null; }
    public ServiceAuthorizationManager(){}
    public Set<Class<? extends Object>> getProtocolsWithAcls(){ return null; }
    public Set<Class<? extends Object>> getProtocolsWithMachineLists(){ return null; }
    public static Logger AUDITLOG = null;
    public static String SERVICE_AUTHORIZATION_CONFIG = null;
    public void authorize(UserGroupInformation p0, Class<? extends Object> p1, Configuration p2, InetAddress p3){}
    public void refresh(Configuration p0, PolicyProvider p1){}
    public void refreshWithLoadedConfiguration(Configuration p0, PolicyProvider p1){}
}
