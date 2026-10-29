package main

//go:generate depstubber -vendor github.com/onsi/ginkgo "" Fail,RunSpecs
//go:generate depstubber -vendor github.com/onsi/gomega "" RegisterFailHandler

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestClassifyFiles(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "ClassifyFiles Suite")
}
