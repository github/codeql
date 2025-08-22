// Generated automatically from org.openhealthtools.mdht.uml.cda.RelatedSubject for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.SubjectPerson;
import org.openhealthtools.mdht.uml.hl7.datatypes.AD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.TEL;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.x_DocumentSubject;

public interface RelatedSubject extends Role
{
    CE getCode();
    EList<AD> getAddrs();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    EList<TEL> getTelecoms();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    SubjectPerson getSubject();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    void setClassCode(x_DocumentSubject p0);
    void setCode(CE p0);
    void setNullFlavor(NullFlavor p0);
    void setSubject(SubjectPerson p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
    x_DocumentSubject getClassCode();
}
