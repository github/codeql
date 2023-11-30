// Generated automatically from org.openhealthtools.mdht.uml.cda.IntendedRecipient for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Organization;
import org.openhealthtools.mdht.uml.cda.Person;
import org.openhealthtools.mdht.uml.hl7.datatypes.AD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.TEL;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.x_InformationRecipientRole;

public interface IntendedRecipient extends Role
{
    EList<AD> getAddrs();
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    EList<TEL> getTelecoms();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Organization getReceivedOrganization();
    Person getInformationRecipient();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    void setClassCode(x_InformationRecipientRole p0);
    void setInformationRecipient(Person p0);
    void setNullFlavor(NullFlavor p0);
    void setReceivedOrganization(Organization p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
    x_InformationRecipientRole getClassCode();
}
