using Xunit;
using Semmle.Util;
using Semmle.Extraction.CSharp;

namespace Semmle.Extraction.Tests
{
    public class OverlayTests
    {
        [Fact]
        public void TestOverlay()
        {
            var logger = new LoggerStub();
            var json =
                """
                {
                    "changes": [
                        "app/controllers/about_controller.xyz",
                        "app/models/about.xyz"
                    ]
                }
                """;
            var overlay = new OverlayInfo(logger, json);

            Assert.True(overlay.IsOverlayMode);
            Assert.False(overlay.OnlyMakeScaffold("app/controllers/about_controller.xyz"));
            Assert.False(overlay.OnlyMakeScaffold("app/models/about.xyz"));
            Assert.True(overlay.OnlyMakeScaffold("app/models/unchanged.xyz"));
        }
    }
}
