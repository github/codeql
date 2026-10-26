// Generated automatically from javafx.scene.input.KeyCombination for testing purposes

package javafx.scene.input;

import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;

abstract public class KeyCombination
{
    protected KeyCombination() {}
    protected KeyCombination(KeyCombination.Modifier... p0){}
    protected KeyCombination(KeyCombination.ModifierValue p0, KeyCombination.ModifierValue p1, KeyCombination.ModifierValue p2, KeyCombination.ModifierValue p3, KeyCombination.ModifierValue p4){}
    public String getDisplayText(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean match(KeyEvent p0){ return false; }
    public final KeyCombination.ModifierValue getAlt(){ return null; }
    public final KeyCombination.ModifierValue getControl(){ return null; }
    public final KeyCombination.ModifierValue getMeta(){ return null; }
    public final KeyCombination.ModifierValue getShift(){ return null; }
    public final KeyCombination.ModifierValue getShortcut(){ return null; }
    public int hashCode(){ return 0; }
    public static KeyCombination NO_MATCH = null;
    public static KeyCombination keyCombination(String p0){ return null; }
    public static KeyCombination valueOf(String p0){ return null; }
    public static KeyCombination.Modifier ALT_ANY = null;
    public static KeyCombination.Modifier ALT_DOWN = null;
    public static KeyCombination.Modifier CONTROL_ANY = null;
    public static KeyCombination.Modifier CONTROL_DOWN = null;
    public static KeyCombination.Modifier META_ANY = null;
    public static KeyCombination.Modifier META_DOWN = null;
    public static KeyCombination.Modifier SHIFT_ANY = null;
    public static KeyCombination.Modifier SHIFT_DOWN = null;
    public static KeyCombination.Modifier SHORTCUT_ANY = null;
    public static KeyCombination.Modifier SHORTCUT_DOWN = null;
    static public class Modifier
    {
        protected Modifier() {}
        public KeyCode getKey(){ return null; }
        public KeyCombination.ModifierValue getValue(){ return null; }
        public String toString(){ return null; }
    }
    static public enum ModifierValue
    {
        ANY, DOWN, UP;
        private ModifierValue() {}
    }
}
