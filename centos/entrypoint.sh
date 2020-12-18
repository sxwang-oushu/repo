# Start sshd
echo "gpadmin" | sudo /usr/sbin/sshd
# Start hdfs
start-dfs.sh
hdfs dfs -mkdir -p /tmp
# login
bash -l
