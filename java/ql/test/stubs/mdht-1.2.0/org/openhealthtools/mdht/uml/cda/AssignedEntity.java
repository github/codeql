// Generated automatically from org.openhealthtools.mdht.uml.cda.AssignedEntity for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Organization;
import org.openhealthtools.mdht.uml.cda.Person;
import org.openhealthtools.mdht.uml.cda.SDTCPatient;
import org.openhealthtools.mdht.uml.hl7.datatypes.AD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.TEL;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClassAssignedEntity;

public interface AssignedEntity extends Role
{
    CE getCode();
    EList<AD> getAddrs();
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    EList<Organization> getRepresentedOrganizations();
    EList<TEL> getTelecoms();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Person getAssignedPerson();
    RoleClassAssignedEntity getClassCode();
    SDTCPatient getSDTCPatient();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAssignedPerson(Person p0);
    void setClassCode(RoleClassAssignedEntity p0);
    void setCode(CE p0);
    void setNullFlavor(NullFlavor p0);
    void setSDTCPatient(SDTCPatient p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
