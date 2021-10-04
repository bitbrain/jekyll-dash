#!/bin/bash

SPEC_DATA=$(parse-gemspec-cli $SPECFILE)

echo "::set-output name=name::$(echo $SPEC_DATA | jq -r '.name')"
echo "::set-output name=description::$(echo $SPEC_DATA | jq -r '.description')"
echo "::set-output name=summary::$(echo $SPEC_DATA | jq -r '.summary')"
echo "::set-output name=version::$(echo $SPEC_DATA | jq -r '.version')"
echo "::set-output name=homepage::$(echo $SPEC_DATA | jq -r '.homepage')"