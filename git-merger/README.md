# Git History Merger

Merges Git history of multiple repositories into one complete history.

Takes this a step further and does it automatically, and across multiple folders, recursively.

## Git Commands

When merging `secondrepo/` into `firstgitrepo/`.

````
# Add the second repo as a remote:
cd firstgitrepo/
git remote add secondrepo username@servername:andsoon

# Make sure that you've downloaded all of the secondrepo's commits:
git fetch secondrepo

# Create a local branch from the second repo's branch:
git branch branchfromsecondrepo secondrepo/master

# Move all its files into a subdirectory:
git checkout branchfromsecondrepo
mkdir subdir/
git ls-tree -z --name-only HEAD | xargs -0 -I {} git mv {} subdir/
git commit -m "Moved files to subdir/"

# Merge the second branch into the first repo's master branch:
git checkout master
git merge --allow-unrelated-histories branchfromsecondrepo
````

## Sources

Instructions this script uses are from the following:

https://stackoverflow.com/questions/13040958/merge-two-git-repositories-without-breaking-file-history/20974621#20974621

https://saintgimp.org/2013/01/22/merging-two-git-repositories-into-one-repository-without-losing-file-history/
