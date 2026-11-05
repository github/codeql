using Microsoft.AspNetCore.Mvc;

public class StructuralController : ControllerBase
{
    public void Action(string input) => _ = GetType().Name + input;
}