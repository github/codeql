// Generated automatically from android.app.Person for testing purposes

package android.app;

import android.graphics.drawable.Icon;
import android.os.Parcel;
import android.os.Parcelable;

public class Person implements Parcelable
{
    protected Person() {}
    public CharSequence getName(){ return null; }
    public Icon getIcon(){ return null; }
    public Person.Builder toBuilder(){ return null; }
    public String getKey(){ return null; }
    public String getUri(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isBot(){ return false; }
    public boolean isImportant(){ return false; }
    public int describeContents(){ return 0; }
    public int hashCode(){ return 0; }
    public static Parcelable.Creator<Person> CREATOR = null;
    public void writeToParcel(Parcel p0, int p1){}
    static public class Builder
    {
        public Builder(){}
        public Person build(){ return null; }
        public Person.Builder setBot(boolean p0){ return null; }
        public Person.Builder setIcon(Icon p0){ return null; }
        public Person.Builder setImportant(boolean p0){ return null; }
        public Person.Builder setKey(String p0){ return null; }
        public Person.Builder setName(CharSequence p0){ return null; }
        public Person.Builder setUri(String p0){ return null; }
    }
}
