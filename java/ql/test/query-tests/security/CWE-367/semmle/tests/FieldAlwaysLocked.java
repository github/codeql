package test.cwe367.semmle.tests;

import java.util.Enumeration;
import java.util.Hashtable;

class FieldAlwaysLocked {

        Hashtable field;

        public FieldAlwaysLocked() {
                field = new Hashtable();
        }

        protected synchronized void checkOut() {
                Object o;
                if (field.size() > 0) {
                        Enumeration e = field.keys();
                        while (e.hasMoreElements()) {
                                o = e.nextElement();
                                field.remove(o);
                        }
                }
        }
}
