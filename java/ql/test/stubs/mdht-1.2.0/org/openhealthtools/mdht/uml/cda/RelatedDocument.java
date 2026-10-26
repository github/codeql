// Generated automatically from org.openhealthtools.mdht.uml.cda.RelatedDocument for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.ParentDocument;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.ActRelationship;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.x_ActRelationshipDocument;

public interface RelatedDocument extends ActRelationship
{
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ParentDocument getParentDocument();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    void setNullFlavor(NullFlavor p0);
    void setParentDocument(ParentDocument p0);
    void setTypeCode(x_ActRelationshipDocument p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetNullFlavor();
    void unsetTypeCode();
    x_ActRelationshipDocument getTypeCode();
}
