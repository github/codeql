package p;

import java.util.List;
import java.util.ArrayList;

public class TypeBasedCollection<T> extends ArrayList<T> {

    public void addT(T x) {
        throw null;
    }

    public void addManyT(List<T> xs) {
        throw null;
    }

    public T firstT() {
        throw null;
    }

    public List<T> getManyT() {
        throw null;
    }
}