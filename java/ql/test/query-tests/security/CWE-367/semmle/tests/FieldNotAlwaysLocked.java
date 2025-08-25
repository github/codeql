package test.cwe367.semmle.tests;

import java.util.Enumeration;
import java.util.Hashtable;

class FieldNotAlwaysLocked {

        Hashtable field;

        public FieldNotAlwaysLocked() {
                field = new Hashtable();
        }

        protected synchronized void checkOut() {
                Object o;
                if (field.size() > 0) {
                        Enumeration e = field.keys(); // $ Alert
                        while (e.hasMoreElements()) {
                                o = e.nextElement();
                                field.remove(o); // $ Alert
                        }
                }
        }

        protected void modifyUnlocked() {
                field = new Hashtable();
        }
}
