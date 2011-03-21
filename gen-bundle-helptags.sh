#!/bin/sh

for bundle in bundle/*; do
  if [ -f "${bundle}/doc/tags" ]; then
    next
  else
    vim --noplugin -u /dev/null --cmd "helptags $bundle/doc" --cmd "q"
  fi
done
