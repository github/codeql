OS=$(shell uname)
ifeq ($(OS),Darwin)
SDK=-sdk $(shell xcrun -show-sdk-path)
FRONTEND=$(shell xcrun -find swift-frontend)
else
SDK=""
FRONTEND=swiftc
endif

all:
	$(FRONTEND) -frontend -c A.swift $(SDK)
	$(FRONTEND) -frontend -c B.swift -o B.o $(SDK)
	$(FRONTEND) -frontend -c -primary-file C.swift $(SDK)
	$(FRONTEND) -frontend -c -primary-file D.swift -o D.o $(SDK)
	$(FRONTEND) -frontend -c -primary-file E.swift Esup.swift -o E.o $(SDK)
