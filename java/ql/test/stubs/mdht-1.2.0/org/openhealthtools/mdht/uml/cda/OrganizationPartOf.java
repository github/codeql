// Generated automatically from org.openhealthtools.mdht.uml.cda.OrganizationPartOf for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Organization;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClass;

public interface OrganizationPartOf extends Role
{
    CE getCode();
    CS getStatusCode();
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    IVL_TS getEffectiveTime();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Organization getWholeOrganization();
    RoleClass getClassCode();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(RoleClass p0);
    void setCode(CE p0);
    void setEffectiveTime(IVL_TS p0);
    void setNullFlavor(NullFlavor p0);
    void setStatusCode(CS p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void setWholeOrganization(Organization p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
