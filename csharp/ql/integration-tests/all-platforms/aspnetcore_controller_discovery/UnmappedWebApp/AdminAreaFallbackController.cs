using Microsoft.AspNetCore.Mvc;

namespace AdminArea;

[Area("Admin")]
public class AreaFallbackController
{
    public void Index(string input) => _ = GetType().Name + input;
}
