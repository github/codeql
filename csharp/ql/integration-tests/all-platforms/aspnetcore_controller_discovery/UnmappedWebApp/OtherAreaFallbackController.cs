using Microsoft.AspNetCore.Mvc;

namespace OtherArea;

[Area("Other")]
public class AreaFallbackController
{
    public void Index(string input) => _ = GetType().Name + input;
}
