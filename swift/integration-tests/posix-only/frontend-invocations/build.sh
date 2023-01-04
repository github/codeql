#!/bin/bash

if [[ "$(uname)" == Darwin ]]; then
  SDK="-sdk $(xcrun -show-sdk-path)"
  FRONTEND="$(xcrun -find swift-frontend)"
else
  SDK=""
  FRONTEND="swift-frontend"
fi

$FRONTEND -frontend -c A.swift $SDK
$FRONTEND -frontend -c B.swift -o B.o $SDK
$FRONTEND -frontend -c -primary-file C.swift $SDK
$FRONTEND -frontend -c -primary-file D.swift -o D.o $SDK
$FRONTEND -frontend -c -primary-file E.swift Esup.swift -o E.o $SDK
$FRONTEND -frontend -emit-module -primary-file F1.swift F2.swift -module-name F -o F1.swiftmodule $SDK
$FRONTEND -frontend -emit-module F1.swift -primary-file F2.swift -module-name F -o F2.swiftmodule $SDK
$FRONTEND -merge-modules F1.swiftmodule F2.swiftmodule -o F.swiftmodule $SDK
( cd dir; $FRONTEND -frontend -c ../G.swift $SDK )
