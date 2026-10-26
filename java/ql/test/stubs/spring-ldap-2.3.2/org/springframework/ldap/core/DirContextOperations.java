// Generated automatically from org.springframework.ldap.core.DirContextOperations for testing purposes

package org.springframework.ldap.core;

import javax.naming.Name;
import javax.naming.directory.DirContext;
import org.springframework.LdapDataEntry;
import org.springframework.ldap.core.AttributeModificationsAware;

public interface DirContextOperations extends AttributeModificationsAware, DirContext, LdapDataEntry
{
    String getNameInNamespace();
    String getReferralUrl();
    String[] getNamesOfModifiedAttributes();
    boolean isReferral();
    boolean isUpdateMode();
    void setDn(Name p0);
    void update();
}
