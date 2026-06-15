#!/bin/bash -x

if [[ "$(uname)" == Darwin ]]; then
  SDK="-sdk $(xcrun -show-sdk-path)"
  FRONTEND="$(xcrun -find swift-frontend)"
else
  SDK=""
  FRONTEND="swift-frontend"
fi

function invoke() {
  $FRONTEND -frontend "$@" $SDK
}

rm -rf *.swiftmodule *.o

invoke -c A.swift
invoke -c B.swift -o B.o
invoke -c -primary-file C.swift
invoke -c -primary-file D.swift -o D.o
invoke -c -primary-file E.swift Esup.swift -o E.o
invoke -emit-module -primary-file F1.swift F2.swift -module-name F -o F1.swiftmodule
invoke -emit-module F1.swift -primary-file F2.swift -module-name F -o F2.swiftmodule
invoke -emit-module F3.swift F4.swift -o Fs.swiftmodule
invoke -emit-module -merge-modules F1.swiftmodule F2.swiftmodule -o F.swiftmodule
invoke -c F5.swift -o F5.o -I.
( cd dir; invoke -c ../G.swift )
invoke -c -primary-file H1.swift -primary-file H2.swift H3.swift -emit-module-path H1.swiftmodule -emit-module-path H2.swiftmodule -o H1.o -o H2.o
invoke -emit-module -primary-file I1.swift -primary-file I2.swift -o I1.swiftmodule -o I2.swiftmodule
