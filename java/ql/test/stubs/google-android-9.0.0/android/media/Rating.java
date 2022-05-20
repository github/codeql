// Generated automatically from android.media.Rating for testing purposes

package android.media;

import android.os.Parcel;
import android.os.Parcelable;

public class Rating implements Parcelable
{
    protected Rating() {}
    public String toString(){ return null; }
    public boolean hasHeart(){ return false; }
    public boolean isRated(){ return false; }
    public boolean isThumbUp(){ return false; }
    public float getPercentRating(){ return 0; }
    public float getStarRating(){ return 0; }
    public int describeContents(){ return 0; }
    public int getRatingStyle(){ return 0; }
    public static Parcelable.Creator<Rating> CREATOR = null;
    public static Rating newHeartRating(boolean p0){ return null; }
    public static Rating newPercentageRating(float p0){ return null; }
    public static Rating newStarRating(int p0, float p1){ return null; }
    public static Rating newThumbRating(boolean p0){ return null; }
    public static Rating newUnratedRating(int p0){ return null; }
    public static int RATING_3_STARS = 0;
    public static int RATING_4_STARS = 0;
    public static int RATING_5_STARS = 0;
    public static int RATING_HEART = 0;
    public static int RATING_NONE = 0;
    public static int RATING_PERCENTAGE = 0;
    public static int RATING_THUMB_UP_DOWN = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
