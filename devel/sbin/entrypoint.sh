# Start sshd
echo "oushu" | sudo -S service ssh start
# Start hdfs
start-dfs.sh
hdfs dfs -mkdir -p /tmp
# login
bash -l
