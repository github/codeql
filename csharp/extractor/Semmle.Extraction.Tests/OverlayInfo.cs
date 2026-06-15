using Xunit;
using Semmle.Extraction.CSharp;
using System.IO;

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

            var overlay = new OverlayInfo(logger, "overlay/source/path", json);

            Assert.True(overlay.IsOverlayMode);
            Assert.False(overlay.OnlyMakeScaffold("overlay/source/path" + Path.DirectorySeparatorChar + "app/controllers/about_controller.xyz"));
            Assert.False(overlay.OnlyMakeScaffold("overlay/source/path" + Path.DirectorySeparatorChar + "app/models/about.xyz"));
            Assert.True(overlay.OnlyMakeScaffold("overlay/source/path" + Path.DirectorySeparatorChar + "app/models/unchanged.xyz"));
        }
    }
}
