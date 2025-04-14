#!/bin/bash

SDK="-sdk $(xcrun -show-sdk-path)"
FRONTEND="$(xcrun -find swift-frontend)"

# This test case will only work on a case-insensitive FS (which is the default)
$FRONTEND -frontend -c MIXEDCASE.swift $SDK
