#!/bin/bash -eu

# Workaround for https://github.com/Automattic/buildkite-ci/issues/79
echo "--- :rubygems: Fix Ruby Setup"
gem install bundler

echo "--- :rubygems: Set up Gems"
install_gems

echo "--- Install Pods"
# We need the pods because that's where SwiftFormat (used by Danger) comes from
install_cocoapods

echo "--- :warning: Run Danger"
bundle exec danger --fail-on-errors=true