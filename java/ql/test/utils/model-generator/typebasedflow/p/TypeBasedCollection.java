package p;

import java.util.List;
import java.util.ArrayList;

public class TypeBasedCollection<T> extends ArrayList<T> {

    // MaD=p;TypeBasedCollection;true;addT;(Object);;Argument[0];Argument[-1].Element;value;generated
    public void addT(T x) {
    }

    // MaD=p;TypeBasedCollection;true;addManyT;(List);;Argument[0].Element;Argument[-1].Element;value;generated
    public void addManyT(List<T> xs) {
    }

    // MaD=p;TypeBasedCollection;true;firstT;();;Argument[-1].Element;ReturnValue;value;generated
    public T firstT() {
        return null;
    }

    // MaD=p;TypeBasedCollection;true;getManyT;();;Argument[-1].Element;ReturnValue.Element;value;generated
    public List<T> getManyT() {
        return null;
    }
}