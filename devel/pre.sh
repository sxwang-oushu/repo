set -ex
(
cd libhdfs3
git checkout master
)
(
cd hornet-opensource
git checkout master
cp pre-push .git/hooks/pre-push
cp pre-commit .git/hooks/pre-commit
cp commit-msg .git/hooks/commit-msg
)
(
cd hornet
git checkout master
cp pre-push .git/hooks/pre-push
cp pre-commit .git/hooks/pre-commit
cp commit-msg .git/hooks/commit-msg
)
(
cd hawq
git checkout oushu-master
)
