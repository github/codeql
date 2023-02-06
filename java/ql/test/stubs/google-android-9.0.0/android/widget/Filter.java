// Generated automatically from android.widget.Filter for testing purposes

package android.widget;


abstract public class Filter
{
    protected abstract Filter.FilterResults performFiltering(CharSequence p0);
    protected abstract void publishResults(CharSequence p0, Filter.FilterResults p1);
    public CharSequence convertResultToString(Object p0){ return null; }
    public Filter(){}
    public final void filter(CharSequence p0){}
    public final void filter(CharSequence p0, Filter.FilterListener p1){}
    static class FilterResults
    {
        public FilterResults(){}
        public Object values = null;
        public int count = 0;
    }
    static public interface FilterListener
    {
        void onFilterComplete(int p0);
    }
}
