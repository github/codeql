"Generated"

load(":paket.powershell.bzl", _powershell = "powershell")

def _powershell_impl(module_ctx):
    _powershell()
    return module_ctx.extension_metadata(reproducible = True)

powershell_extension = module_extension(
    implementation = _powershell_impl,
)
