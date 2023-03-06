// Generated automatically from org.apache.hadoop.util.MachineList for testing purposes

package org.apache.hadoop.util;

import java.net.InetAddress;
import java.util.Collection;
import org.slf4j.Logger;

public class MachineList
{
    protected MachineList() {}
    public Collection<String> getCollection(){ return null; }
    public MachineList(Collection<String> p0){}
    public MachineList(Collection<String> p0, MachineList.InetAddressFactory p1){}
    public MachineList(String p0){}
    public boolean includes(String p0){ return false; }
    public static Logger LOG = null;
    public static String WILDCARD_VALUE = null;
    static public class InetAddressFactory
    {
        public InetAddress getByName(String p0){ return null; }
        public InetAddressFactory(){}
    }
}
