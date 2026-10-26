// Generated automatically from org.apache.hadoop.security.authorize.PolicyProvider for testing purposes

package org.apache.hadoop.security.authorize;

import org.apache.hadoop.security.authorize.Service;

abstract public class PolicyProvider
{
    public PolicyProvider(){}
    public abstract Service[] getServices();
    public static PolicyProvider DEFAULT_POLICY_PROVIDER = null;
    public static String POLICY_PROVIDER_CONFIG = null;
}
