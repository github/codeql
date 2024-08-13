using System.Management.Automation.Language;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal abstract class CachedEntity<T> : Extraction.CachedEntity<T> where T : notnull
    {
        public PowerShellContext PowerShellContext => (PowerShellContext)base.Context;

        /// <summary>
        /// Call PowerShellContext.CreateLocation on the ReportingLocation and return result
        /// </summary>
        internal Location TrapSuitableLocation => PowerShellContext.CreateLocation(ReportingLocation);
        
        protected CachedEntity(PowerShellContext powerShellContext, T symbol)
            : base(powerShellContext, symbol)
        {
        }
    }
}
