#!/usr/bin/env zsh
#
# Update the tags file with the given file.  Presumably this is called by the
# editor when a file has changed.

set -eu

tags=/nix/var/nix/profiles/default/bin/fast-tags

cd $(git rev-parse --show-toplevel)
roots=($(grep -v '^#' haskell-roots))

fnames=($@)

flags=(
  --fully-qualified # I use qualified_tag.py
)
flags+=(--src-prefix=${^roots})

if [[ ! -r tags ]]; then
  echo Generating tags from scratch...
  exec $tags $flags -R .
else
  exec $tags $flags $fnames
fi
