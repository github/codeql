using System;

namespace Semmle.Util
{
    /// <summary>
    /// An instance of this class is used to ensure that the provided
    /// action is executed only once and on the first call to `Run`.
    /// It is thread-safe.
    /// </summary>
    public class Initializer
    {
        private readonly Lazy<bool> doInit;

        public Initializer(Action action)
        {
            doInit = new Lazy<bool>(() =>
            {
                action();
                return true;
            });
        }

        public void Run()
        {
            _ = doInit.Value;
        }
    }
}
