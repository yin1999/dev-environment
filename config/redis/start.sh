redis-server /redis-conf/node-1.conf &
redis-server /redis-conf/node-2.conf &
redis-server /redis-conf/node-3.conf &

# 等待所有后台进程结束
wait
