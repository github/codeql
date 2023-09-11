// Generated automatically from org.openhealthtools.mdht.uml.cda.RelatedEntity for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Person;
import org.openhealthtools.mdht.uml.cda.SDTCPatient;
import org.openhealthtools.mdht.uml.hl7.datatypes.AD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.datatypes.TEL;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClassMutualRelationship;

public interface RelatedEntity extends Role
{
    CE getCode();
    EList<AD> getAddrs();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    EList<TEL> getTelecoms();
    IVL_TS getEffectiveTime();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Person getRelatedPerson();
    RoleClassMutualRelationship getClassCode();
    SDTCPatient getSDTCPatient();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    void setClassCode(RoleClassMutualRelationship p0);
    void setCode(CE p0);
    void setEffectiveTime(IVL_TS p0);
    void setNullFlavor(NullFlavor p0);
    void setRelatedPerson(Person p0);
    void setSDTCPatient(SDTCPatient p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
