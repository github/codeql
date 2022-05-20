// Copyright (c) Corporation for National Research Initiatives
package org.python.core;

// a ThreadState refers to one PySystemState; this weak ref allows for tracking all ThreadState objects
// that refer to a given PySystemState

public class ThreadState {

    public PyException exception;

    public ThreadState(PySystemState systemState) {
        setSystemState(systemState);
    }

    public void setSystemState(PySystemState systemState) {
    }

    public PySystemState getSystemState() {
        return null;
    }

    public boolean enterRepr(PyObject obj) {
        return false;
    }

    public void exitRepr(PyObject obj) {
    }
}
