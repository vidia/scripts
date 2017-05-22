
# Get the options from the arguments.
while getopts s:d: opts; do
   case ${opts} in
      s) SOURCE_REPO=${OPTARG} ;;
      d) DEST_REPO=${OPTARG} ;;
   esac
done

# Validation.

# make sure a source was given.
# Make sure it is a full path and exists and is a repo.
# make it end with a ".git" for proper remote adding.
if [ -z ${SOURCE_REPO+x} ];
then
  echo "Please provide a source repo using the -s option.";
  exit;
else
  echo "The source repo is '$SOURCE_REPO'";
fi

# make sure a dest was given.
# Make sure it is a full path and exists and is a repo.
if [ -z ${DEST_REPO+x} ];
then
  echo "Please provide a destination repo using the -d option.";
  exit;
else
  echo "The destination repo is '$DEST_REPO'";
fi

# Move the repo history.

REMOTE_NAME=repoToAdd$(((RANDOM % 10000)+ 1))
git -C $DEST_REPO remote add $REMOTE_NAME $SOURCE_REPO
git -C $DEST_REPO fetch $REMOTE_NAME
git -C $DEST_REPO branch ${REMOTE_NAME}_master $REMOTE_NAME/master
git -C $DEST_REPO checkout ${REMOTE_NAME}_master

# The files are in the root, make a subdir and move them to there.
SOURCE_REL_PATH_IN_DEST=abc123foobar
# mkdir with all path segments.
mkdir $DEST_REPO/$SOURCE_REL_PATH_IN_DEST
# Possible that I need to "cd" at this point to make this work. Need confirmation of xargs.
git -C $DEST_REPO ls-tree -z --name-only HEAD | xargs -0 -I {} git mv {} $SOURCE_REL_PATH_IN_DEST/
git -C $DEST_REPO commit -m "Moved the files for $SOURCE_REPO into a subdirectory."

git -C $DEST_REPO checkout master
git -C $DEST_REPO merge --allow-unrelated-histories ${REMOTE_NAME}_master




-----------------------------
When merging `secondrepo/` into `firstgitrepo/`.

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
