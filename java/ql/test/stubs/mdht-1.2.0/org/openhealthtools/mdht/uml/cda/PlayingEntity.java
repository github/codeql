// Generated automatically from org.openhealthtools.mdht.uml.cda.PlayingEntity for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.ED;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.PN;
import org.openhealthtools.mdht.uml.hl7.datatypes.PQ;
import org.openhealthtools.mdht.uml.hl7.datatypes.TS;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityClassRoot;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityDeterminer;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface PlayingEntity extends org.openhealthtools.mdht.uml.hl7.rim.Entity
{
    CE getCode();
    ED getDesc();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    EList<PN> getNames();
    EList<PQ> getQuantities();
    EntityClassRoot getClassCode();
    EntityDeterminer getDeterminerCode();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    TS getSDTCBirthTime();
    boolean isSetClassCode();
    boolean isSetDeterminerCode();
    boolean isSetNullFlavor();
    boolean validateDeterminerCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(EntityClassRoot p0);
    void setCode(CE p0);
    void setDesc(ED p0);
    void setDeterminerCode(EntityDeterminer p0);
    void setNullFlavor(NullFlavor p0);
    void setSDTCBirthTime(TS p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetDeterminerCode();
    void unsetNullFlavor();
}
