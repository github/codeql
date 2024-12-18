#!/bin/bash

for dir in Foo1 Foo2; do
  (
    cd $dir
    swift package clean
    swift build
  )
done
