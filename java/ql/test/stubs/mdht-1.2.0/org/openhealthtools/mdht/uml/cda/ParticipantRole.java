// Generated automatically from org.openhealthtools.mdht.uml.cda.ParticipantRole for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.Device;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.PlayingEntity;
import org.openhealthtools.mdht.uml.hl7.datatypes.AD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.TEL;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClassRoot;

public interface ParticipantRole extends Role
{
    CE getCode();
    Device getPlayingDevice();
    EList<AD> getAddrs();
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    EList<TEL> getTelecoms();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    PlayingEntity getPlayingEntity();
    RoleClassRoot getClassCode();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    boolean validatePlayingEntityChoice(DiagnosticChain p0, Map<Object, Object> p1);
    org.openhealthtools.mdht.uml.cda.Entity getScopingEntity();
    void setClassCode(RoleClassRoot p0);
    void setCode(CE p0);
    void setNullFlavor(NullFlavor p0);
    void setPlayingDevice(Device p0);
    void setPlayingEntity(PlayingEntity p0);
    void setScopingEntity(org.openhealthtools.mdht.uml.cda.Entity p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
