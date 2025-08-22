// Generated automatically from org.eclipse.emf.common.notify.Notification for testing purposes

package org.eclipse.emf.common.notify;


public interface Notification
{
    Object getFeature();
    Object getNewValue();
    Object getNotifier();
    Object getOldValue();
    String getNewStringValue();
    String getOldStringValue();
    boolean getNewBooleanValue();
    boolean getOldBooleanValue();
    boolean isReset();
    boolean isTouch();
    boolean merge(Notification p0);
    boolean wasSet();
    byte getNewByteValue();
    byte getOldByteValue();
    char getNewCharValue();
    char getOldCharValue();
    double getNewDoubleValue();
    double getOldDoubleValue();
    float getNewFloatValue();
    float getOldFloatValue();
    int getEventType();
    int getFeatureID(Class<? extends Object> p0);
    int getNewIntValue();
    int getOldIntValue();
    int getPosition();
    long getNewLongValue();
    long getOldLongValue();
    short getNewShortValue();
    short getOldShortValue();
    static int ADD = 0;
    static int ADD_MANY = 0;
    static int CREATE = 0;
    static int EVENT_TYPE_COUNT = 0;
    static int MOVE = 0;
    static int NO_FEATURE_ID = 0;
    static int NO_INDEX = 0;
    static int REMOVE = 0;
    static int REMOVE_MANY = 0;
    static int REMOVING_ADAPTER = 0;
    static int RESOLVE = 0;
    static int SET = 0;
    static int UNSET = 0;
}
