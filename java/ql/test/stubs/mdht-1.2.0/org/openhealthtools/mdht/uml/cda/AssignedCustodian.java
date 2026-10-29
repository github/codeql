// Generated automatically from org.openhealthtools.mdht.uml.cda.AssignedCustodian for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.CustodianOrganization;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClassAssignedEntity;

public interface AssignedCustodian extends Role
{
    CustodianOrganization getRepresentedCustodianOrganization();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    RoleClassAssignedEntity getClassCode();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(RoleClassAssignedEntity p0);
    void setNullFlavor(NullFlavor p0);
    void setRepresentedCustodianOrganization(CustodianOrganization p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
