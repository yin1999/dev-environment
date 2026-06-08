# 捕获 SIGTERM/SIGINT，转发给所有 redis-server 子进程
trap 'echo "Received signal, stopping Redis nodes..."; kill $PID1 $PID2 $PID3; wait $PID1 $PID2 $PID3; exit 0' TERM INT

redis-server /redis-conf/node-1.conf &
PID1=$!
redis-server /redis-conf/node-2.conf &
PID2=$!
redis-server /redis-conf/node-3.conf &
PID3=$!

# 等待节点就绪
for port in 6380 6381 6382; do
  while ! redis-cli -p $port ping > /dev/null 2>&1; do
    sleep 0.5
  done
done

# 初始化集群（如果尚未创建）
if ! redis-cli -p 6380 cluster info 2>/dev/null | grep -q 'cluster_state:ok'; then
  echo "Creating Redis cluster..."
  echo "yes" | redis-cli --cluster create 127.0.0.1:6380 127.0.0.1:6381 127.0.0.1:6382 --cluster-replicas 0
else
  echo "Redis cluster already exists"
fi

# 等待所有后台进程结束
wait $PID1 $PID2 $PID3
