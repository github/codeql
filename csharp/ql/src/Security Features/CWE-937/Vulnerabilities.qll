/**
 * Provides a list of NuGet packages with known vulnerabilities.
 *
 * To add a new vulnerability follow the existing pattern.
 * Create a new class that extends the abstract class `Vulnerability`,
 * supplying the name and the URL, and override one (or both) of
 * `matchesRange` and `matchesVersion`.
 */

import csharp
import Vulnerability

class MicrosoftAdvisory4021279 extends Vulnerability {
  MicrosoftAdvisory4021279() { this = "Microsoft Security Advisory 4021279" }

  override string getUrl() { result = "https://github.com/dotnet/corefx/issues/19535" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    name = "System.Text.Encodings.Web" and
    (
      affected = "4.0.0" and fixed = "4.0.1"
      or
      affected = "4.3.0" and fixed = "4.3.1"
    )
    or
    name = "System.Net.Http" and
    (
      affected = "4.1.1" and fixed = "4.1.2"
      or
      affected = "4.3.1" and fixed = "4.3.2"
    )
    or
    name = "System.Net.Http.WinHttpHandler" and
    (
      affected = "4.0.1" and fixed = "4.0.2"
      or
      affected = "4.3.0" and fixed = "4.3.1"
    )
    or
    name = "System.Net.Security" and
    (
      affected = "4.0.0" and fixed = "4.0.1"
      or
      affected = "4.3.0" and fixed = "4.3.1"
    )
    or
    (
      name = "Microsoft.AspNetCore.Mvc"
      or
      name = "Microsoft.AspNetCore.Mvc.Core"
      or
      name = "Microsoft.AspNetCore.Mvc.Abstractions"
      or
      name = "Microsoft.AspNetCore.Mvc.ApiExplorer"
      or
      name = "Microsoft.AspNetCore.Mvc.Cors"
      or
      name = "Microsoft.AspNetCore.Mvc.DataAnnotations"
      or
      name = "Microsoft.AspNetCore.Mvc.Formatters.Json"
      or
      name = "Microsoft.AspNetCore.Mvc.Formatters.Xml"
      or
      name = "Microsoft.AspNetCore.Mvc.Localization"
      or
      name = "Microsoft.AspNetCore.Mvc.Razor.Host"
      or
      name = "Microsoft.AspNetCore.Mvc.Razor"
      or
      name = "Microsoft.AspNetCore.Mvc.TagHelpers"
      or
      name = "Microsoft.AspNetCore.Mvc.ViewFeatures"
      or
      name = "Microsoft.AspNetCore.Mvc.WebApiCompatShim"
    ) and
    (
      affected = "1.0.0" and fixed = "1.0.4"
      or
      affected = "1.1.0" and fixed = "1.1.3"
    )
  }
}

class CVE_2017_8700 extends Vulnerability {
  CVE_2017_8700() { this = "CVE-2017-8700" }

  override string getUrl() { result = "https://github.com/aspnet/Announcements/issues/279" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    (
      name = "Microsoft.AspNetCore.Mvc.Core"
      or
      name = "Microsoft.AspNetCore.Mvc.Cors"
    ) and
    (
      affected = "1.0.0" and fixed = "1.0.6"
      or
      affected = "1.1.0" and fixed = "1.1.6"
    )
  }
}

class CVE_2018_0765 extends Vulnerability {
  CVE_2018_0765() { this = "CVE-2018-0765" }

  override string getUrl() { result = "https://github.com/dotnet/announcements/issues/67" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    name = "System.Security.Cryptography.Xml" and
    affected = "0.0.0" and
    fixed = "4.4.2"
  }
}

class AspNetCore_Mar18 extends Vulnerability {
  AspNetCore_Mar18() { this = "ASPNETCore-Mar18" }

  override string getUrl() { result = "https://github.com/aspnet/Announcements/issues/300" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    (
      name = "Microsoft.AspNetCore.Server.Kestrel.Core"
      or
      name = "Microsoft.AspNetCore.Server.Kestrel.Transport.Abstractions"
      or
      name = "Microsoft.AspNetCore.Server.Kestrel.Transport.Libuv"
    ) and
    affected = "2.0.0" and
    fixed = "2.0.3"
    or
    name = "Microsoft.AspNetCore.All" and
    affected = "2.0.0" and
    fixed = "2.0.8"
  }
}

class CVE_2018_8409 extends Vulnerability {
  CVE_2018_8409() { this = "CVE-2018-8409" }

  override string getUrl() { result = "https://github.com/aspnet/Announcements/issues/316" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    name = "System.IO.Pipelines" and affected = "4.5.0" and fixed = "4.5.1"
    or
    (name = "Microsoft.AspNetCore.All" or name = "Microsoft.AspNetCore.App") and
    affected = "2.1.0" and
    fixed = "2.1.4"
  }
}

class CVE_2018_8171 extends Vulnerability {
  CVE_2018_8171() { this = "CVE-2018-8171" }

  override string getUrl() { result = "https://github.com/aspnet/Announcements/issues/310" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    name = "Microsoft.AspNetCore.Identity" and
    (
      affected = "1.0.0" and fixed = "1.0.6"
      or
      affected = "1.1.0" and fixed = "1.1.6"
      or
      affected = "2.0.0" and fixed = "2.0.4"
      or
      affected = "2.1.0" and fixed = "2.1.2"
    )
  }
}

class CVE_2018_8356 extends Vulnerability {
  CVE_2018_8356() { this = "CVE-2018-8356" }

  override string getUrl() { result = "https://github.com/dotnet/announcements/issues/73" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    (
      name = "System.Private.ServiceModel"
      or
      name = "System.ServiceModel.Http"
      or
      name = "System.ServiceModel.NetTcp"
    ) and
    (
      affected = "4.0.0" and fixed = "4.1.3"
      or
      affected = "4.3.0" and fixed = "4.3.3"
      or
      affected = "4.4.0" and fixed = "4.4.4"
      or
      affected = "4.5.0" and fixed = "4.5.3"
    )
    or
    (
      name = "System.ServiceModel.Duplex"
      or
      name = "System.ServiceModel.Security"
    ) and
    (
      affected = "4.0.0" and fixed = "4.0.4"
      or
      affected = "4.3.0" and fixed = "4.3.3"
      or
      affected = "4.4.0" and fixed = "4.4.4"
      or
      affected = "4.5.0" and fixed = "4.5.3"
    )
    or
    name = "System.ServiceModel.NetTcp" and
    (
      affected = "4.0.0" and fixed = "4.1.3"
      or
      affected = "4.3.0" and fixed = "4.3.3"
      or
      affected = "4.4.0" and fixed = "4.4.4"
      or
      affected = "4.5.0" and fixed = "4.5.1"
    )
  }
}

class ASPNETCore_Jul18 extends Vulnerability {
  ASPNETCore_Jul18() { this = "ASPNETCore-July18" }

  override string getUrl() { result = "https://github.com/aspnet/Announcements/issues/311" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    name = "Microsoft.AspNetCore.Server.Kestrel.Core" and
    (
      affected = "2.0.0" and fixed = "2.0.4"
      or
      affected = "2.1.0" and fixed = "2.1.2"
    )
    or
    name = "Microsoft.AspNetCore.All" and
    (
      affected = "2.0.0" and fixed = "2.0.9"
      or
      affected = "2.1.0" and fixed = "2.1.2"
    )
    or
    name = "Microsoft.AspNetCore.App" and
    affected = "2.1.0" and
    fixed = "2.1.2"
  }
}

class CVE_2018_8292 extends Vulnerability {
  CVE_2018_8292() { this = "CVE-2018-8292" }

  override string getUrl() { result = "https://github.com/dotnet/announcements/issues/88" }

  override predicate matchesVersion(string name, Version affected, Version fixed) {
    name = "System.Net.Http" and
    (
      affected = "2.0" or
      affected = "4.0.0" or
      affected = "4.1.0" or
      affected = "1.1.1" or
      affected = "4.1.2" or
      affected = "4.3.0" or
      affected = "4.3.1" or
      affected = "4.3.2" or
      affected = "4.3.3"
    ) and
    fixed = "4.3.4"
  }
}

class CVE_2018_0786 extends Vulnerability {
  CVE_2018_0786() { this = "CVE-2018-0786" }

  override string getUrl() { result = "https://github.com/dotnet/announcements/issues/51" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    (
      name = "System.ServiceModel.Primitives"
      or
      name = "System.ServiceModel.Http"
      or
      name = "System.ServiceModel.NetTcp"
      or
      name = "System.ServiceModel.Duplex"
      or
      name = "System.ServiceModel.Security"
      or
      name = "System.Private.ServiceModel"
    ) and
    (
      affected = "4.4.0" and fixed = "4.4.1"
      or
      affected = "4.3.0" and fixed = "4.3.1"
    )
    or
    (
      name = "System.ServiceModel.Primitives"
      or
      name = "System.ServiceModel.Http"
      or
      name = "System.ServiceModel.NetTcp"
      or
      name = "System.Private.ServiceModel"
    ) and
    affected = "4.1.0" and
    fixed = "4.1.1"
    or
    (
      name = "System.ServiceModel.Duplex"
      or
      name = "System.ServiceModel.Security"
    ) and
    affected = "4.0.1" and
    fixed = "4.0.2"
  }
}

class CVE_2019_0657 extends Vulnerability {
  CVE_2019_0657() { this = "CVE-2019-0657" }

  override predicate matchesRange(string name, Version affected, Version fixed) {
    name = "Microsoft.NETCore.App" and
    (
      affected = "2.1.0" and fixed = "2.1.8"
      or
      affected = "2.2.0" and fixed = "2.2.2"
    )
  }

  override predicate matchesVersion(string name, Version affected, Version fixed) {
    name = "System.Private.Uri" and
    affected = "4.3.0" and
    fixed = "4.3.1"
  }

  override string getUrl() { result = "https://github.com/dotnet/announcements/issues/97" }
}
