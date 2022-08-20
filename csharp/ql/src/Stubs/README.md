# Generate stubs

Stubs can be generated from Nuget packages with the `make_stubs_nuget.py` script.

The following calls generate stubs for `Newtonsoft.Json`:

```
python make_stubs_nuget.py Newtonsoft.Json
python make_stubs_nuget.py Newtonsoft.Json latest
python make_stubs_nuget.py Newtonsoft.Json 13.0.1
python make_stubs_nuget.py Newtonsoft.Json 13.0.1 /Users/tmp/working-dir
```

The output stubs are found in the `[DIR]/output/stubs` folder and can be copied over to `csharp/ql/test/resources/stubs`.

In some more involved cases the output files need to be edited. For example `ServiceStack` has Nuget dependencies, which
are included in the `Microsoft.NETCore.App` framework stub. These dependencies generate empty packages, which can be
removed. The `ProjectReference` entries referencing these removed empty packages also need to be deleted from the
`.csproj` files.