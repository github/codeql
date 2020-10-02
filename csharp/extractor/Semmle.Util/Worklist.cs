using System.Collections.Generic;

namespace Semmle.Util
{
    /// <summary>
    /// A worklist of items, providing the operations of adding an item, checking
    /// whether there are new items and iterating a chunk of unprocessed items.
    /// Any one item will only be accepted into the worklist once.
    /// </summary>
    public class Worklist<T>
    {
        private readonly HashSet<T> internalSet = new HashSet<T>();
        private LinkedList<T> internalList = new LinkedList<T>();
        private bool hasNewElements = false;

        /// <summary>
        /// Gets a value indicating whether this instance has had any new elements added
        /// since the last time <c>GetUnprocessedElements()</c> was called.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance has new elements; otherwise, <c>false</c>.
        /// </value>
        public bool HasNewElements => hasNewElements;

        /// <summary>
        /// Add the specified element to the worklist.
        /// </summary>
        /// <param name='element'>
        /// If set to <c>true</c> element.
        /// </param>
        public bool Add(T element)
        {
            if (internalSet.Contains(element))
                return false;
            internalSet.Add(element);
            internalList.AddLast(element);
            hasNewElements = true;
            return true;
        }

        /// <summary>
        /// Gets the unprocessed elements that have been accumulated since the last time
        /// this method was called. If <c>HasNewElements == true</c>, the resulting list
        /// will be non-empty.
        /// </summary>
        /// <returns>
        /// The unprocessed elements.
        /// </returns>
        public LinkedList<T> GetUnprocessedElements()
        {
            var result = internalList;
            internalList = new LinkedList<T>();
            hasNewElements = false;
            return result;
        }
    }
}
