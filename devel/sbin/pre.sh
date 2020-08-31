set -ex

cd hornet-opensource
git checkout master
cp pre-push .git/hooks/pre-push
cp pre-commit .git/hooks/pre-commit
cp commit-msg .git/hooks/commit-msg
cd ..

cd hornet
git checkout master
cp pre-push .git/hooks/pre-push
cp pre-commit .git/hooks/pre-commit
cp commit-msg .git/hooks/commit-msg
cd ..

cd hawq
git checkout oushu-master
cd ..
