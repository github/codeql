// Generated automatically from org.openhealthtools.mdht.uml.cda.AssignedAuthor for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.AuthoringDevice;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Organization;
import org.openhealthtools.mdht.uml.cda.Person;
import org.openhealthtools.mdht.uml.hl7.datatypes.AD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.TEL;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClassAssignedEntity;

public interface AssignedAuthor extends Role
{
    AuthoringDevice getAssignedAuthoringDevice();
    CE getCode();
    EList<AD> getAddrs();
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    EList<TEL> getTelecoms();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Organization getRepresentedOrganization();
    Person getAssignedPerson();
    RoleClassAssignedEntity getClassCode();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    boolean validateAssignedAuthorChoice(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAssignedAuthoringDevice(AuthoringDevice p0);
    void setAssignedPerson(Person p0);
    void setClassCode(RoleClassAssignedEntity p0);
    void setCode(CE p0);
    void setNullFlavor(NullFlavor p0);
    void setRepresentedOrganization(Organization p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
