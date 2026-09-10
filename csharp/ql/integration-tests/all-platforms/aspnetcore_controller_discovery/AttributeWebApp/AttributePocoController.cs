using Microsoft.AspNetCore.Mvc;

[Route("api/attribute")]
public class AttributePocoController
{
    [HttpGet]
    public void Action(string input) => _ = GetType().Name + input;
}