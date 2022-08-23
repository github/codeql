// Generated automatically from org.apache.sshd.common.channel.PtyMode for testing purposes

package org.apache.sshd.common.channel;

import java.util.Collection;
import java.util.Comparator;
import java.util.Map;
import java.util.NavigableMap;
import java.util.Set;
import java.util.function.ToIntFunction;

public enum PtyMode
{
    CS7, CS8, ECHO, ECHOCTL, ECHOE, ECHOK, ECHOKE, ECHONL, ICANON, ICRNL, IEXTEN, IGNCR, IGNPAR, IMAXBEL, INLCR, INPCK, ISIG, ISTRIP, IUCLC, IUTF8, IXANY, IXOFF, IXON, NOFLSH, OCRNL, OLCUC, ONLCR, ONLRET, ONOCR, OPOST, PARENB, PARMRK, PARODD, PENDIN, TOSTOP, TTY_OP_ISPEED, TTY_OP_OSPEED, VDISCARD, VDSUSP, VEOF, VEOL, VEOL2, VERASE, VFLUSH, VINTR, VKILL, VLNEXT, VQUIT, VREPRINT, VSTART, VSTATUS, VSTOP, VSUSP, VSWTCH, VWERASE, XCASE;
    private PtyMode() {}
    public int toInt(){ return 0; }
    public static Comparator<PtyMode> BY_OPCODE = null;
    public static Integer FALSE_SETTING = null;
    public static Integer TRUE_SETTING = null;
    public static Map<PtyMode, Integer> createEnabledOptions(Collection<PtyMode> p0){ return null; }
    public static Map<PtyMode, Integer> createEnabledOptions(PtyMode... p0){ return null; }
    public static NavigableMap<Integer, PtyMode> COMMANDS = null;
    public static PtyMode fromInt(int p0){ return null; }
    public static PtyMode fromName(String p0){ return null; }
    public static Set<PtyMode> MODES = null;
    public static Set<PtyMode> resolveEnabledOptions(Map<PtyMode, ? extends Object> p0, Collection<PtyMode> p1){ return null; }
    public static Set<PtyMode> resolveEnabledOptions(Map<PtyMode, ? extends Object> p0, PtyMode... p1){ return null; }
    public static ToIntFunction<PtyMode> OPCODE_EXTRACTOR = null;
    public static boolean getBooleanSettingValue(Map<PtyMode, ? extends Object> p0, Collection<PtyMode> p1, boolean p2){ return false; }
    public static boolean getBooleanSettingValue(Map<PtyMode, ? extends Object> p0, PtyMode p1){ return false; }
    public static boolean getBooleanSettingValue(Object p0){ return false; }
    public static boolean getBooleanSettingValue(int p0){ return false; }
    public static boolean isCharSetting(PtyMode p0){ return false; }
    public static byte TTY_OP_END = 0;
}
