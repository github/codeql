// Generated automatically from org.openhealthtools.mdht.uml.cda.HealthCareFacility for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Organization;
import org.openhealthtools.mdht.uml.cda.Place;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClassServiceDeliveryLocation;

public interface HealthCareFacility extends Role
{
    CE getCode();
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Organization getServiceProviderOrganization();
    Place getLocation();
    RoleClassServiceDeliveryLocation getClassCode();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    void setClassCode(RoleClassServiceDeliveryLocation p0);
    void setCode(CE p0);
    void setLocation(Place p0);
    void setNullFlavor(NullFlavor p0);
    void setServiceProviderOrganization(Organization p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
