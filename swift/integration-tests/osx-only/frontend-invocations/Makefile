# TODO: Add linux
SDK=$(shell xcrun -show-sdk-path)
FRONTEND=$(shell xcrun -find swift-frontend)

all:
	$(FRONTEND) -frontend -c A.swift -sdk $(SDK)
	$(FRONTEND) -frontend -c B.swift -o B.o -sdk $(SDK)
	$(FRONTEND) -frontend -c -primary-file C.swift -sdk $(SDK)
	$(FRONTEND) -frontend -c -primary-file D.swift -o D.o -sdk $(SDK)
	$(FRONTEND) -frontend -c -primary-file E.swift Esup.swift -o E.o -sdk $(SDK)
