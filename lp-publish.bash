#!/bin/bash -ex

if [ ! -d ".git/bzr" ]; then
	git-bzr init
fi

git-bzr push lp:~hockeypuck/charms/trusty/hockeypuck/trunk --overwrite
