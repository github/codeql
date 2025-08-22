// Generated automatically from org.openhealthtools.mdht.uml.cda.MaintainedEntity for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Person;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClass;

public interface MaintainedEntity extends Role
{
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    IVL_TS getEffectiveTime();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Person getMaintainingPerson();
    RoleClass getClassCode();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(RoleClass p0);
    void setEffectiveTime(IVL_TS p0);
    void setMaintainingPerson(Person p0);
    void setNullFlavor(NullFlavor p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
