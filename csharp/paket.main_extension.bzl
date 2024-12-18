"Generated"

load(":paket.main.bzl", _main = "main")

def _main_impl(_ctx):
    _main()

main_extension = module_extension(
    implementation = _main_impl,
)
