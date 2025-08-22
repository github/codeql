// Generated automatically from org.openhealthtools.mdht.uml.cda.Component1 for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.EncompassingEncounter;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.ActRelationship;
import org.openhealthtools.mdht.uml.hl7.vocab.ActRelationshipHasComponent;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Component1 extends ActRelationship
{
    ActRelationshipHasComponent getTypeCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    EncompassingEncounter getEncompassingEncounter();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setEncompassingEncounter(EncompassingEncounter p0);
    void setNullFlavor(NullFlavor p0);
    void setTypeCode(ActRelationshipHasComponent p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetNullFlavor();
    void unsetTypeCode();
}
