#!/bin/bash
set -euo pipefail

# Creates fixup commits for the currently unstaged files from the main branch
# to the current head.

# For example, if the following files are unstaged and:
#   - `file1a` and `file1b` were last changed in `commit1`
#   - `file2` was last changed in `commit2`
#   - `file3` was last changed before the tip of the main branch
# this will:
#   - create a fixup commit with `file1a` and `file1b` to be squashed into `commit1`
#   - create a fixup commit with `file2` to be squashed into `commit2`
#   - leave `file3` as unstaged

num_new_commits=0

# List of commits that have been added since the main branch
shas=$(git rev-list --ancestry-path main..HEAD)

for sha in $shas; do
  for changed_file in $(git diff --name-only); do
    # Commit that last changed this file
    last_changed_sha=$(git log -n 1 --pretty=format:%H -- $changed_file)

    if [ $last_changed_sha = $sha ]; then
      git add $changed_file
    fi
  done

  if [ $(git diff --cached --numstat | wc -l) -ne 0 ]; then
    git commit --fixup $sha
    num_new_commits=$((num_new_commits + 1))
  fi
done

if [ $num_new_commits = 0 ]; then
  echo "No commits created"
fi
