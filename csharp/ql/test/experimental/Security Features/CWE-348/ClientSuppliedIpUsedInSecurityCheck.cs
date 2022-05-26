using System;
using Microsoft.AspNetCore.Mvc;

namespace Testing.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClientSuppliedIpUsedInSecurityCheck : ControllerBase
    {
        [HttpGet("bad1")]
        public IActionResult Bad1()
        {
            var ip = GetClientIp();
            if (!ip.StartsWith("192.168."))
            {
                throw new Exception("illegal ip");
            }

            return Ok("Bad");
        }

        [HttpGet("bad2")]
        public IActionResult Bad2()
        {
            var ip = GetClientIp();
            if (!ip.Equals("127.0.0.1"))
            {
                throw new Exception("illegal ip");
            }

            return Ok("Bad");
        }

        [HttpGet("good1")]
        public IActionResult Good1()
        {
            string ip = Request.Headers["X-Forwarded-For"];
            // Good: if this application runs behind a reverse proxy it may append the real,
            // remote IP to the end of any client-supplied X-Forwarded-For header.
            ip = ip.Split(",")[ip.Split(",").Length - 1];

            if (!ip.StartsWith("192.168."))
            {
                throw new Exception("illegal ip");
            }

            return Ok();
        }

        private string GetClientIp()
        {
            var xfHeader = Request.Headers["X-Forwarded-For"];
            if (!string.IsNullOrEmpty(xfHeader))
            {
                return xfHeader.ToString().Split(",")[0];
            }

            xfHeader = Request.HttpContext
                .Connection.RemoteIpAddress?.ToString();

            if (string.IsNullOrEmpty(xfHeader))
            {
                throw new Exception("ip not found");
            }

            return xfHeader;
        }
    }
}
