#!/bin/sh

# Will fail because of a warning
dotnet build

# Pretend it didn't fail, so extraction succeeds (which doesn't treat warnings as errors)
exit 0
