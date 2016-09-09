#!/bin/bash

set -e
set -x

chmod +x dev/bin/git/hooks/*
pushd .git/hooks
rm -vf hook-chain
ln -sfv ../../dev/bin/git/hooks/{hook-chain,pre-push,pre-receive} .
ln -sf hook-chain pre-commit
