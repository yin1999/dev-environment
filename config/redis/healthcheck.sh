# 从 args 中读取要检查的集群节点地址
for port in "$@"; do
    # 使用 redis-cli ping 命令检查节点是否可用
    if ! redis-cli -p "$port" ping > /dev/null 2>&1; then
        echo "Redis node localhost:$port is not reachable."
        exit 1
    else
        echo "Redis node localhost:$port is reachable."
    fi
done

echo "All Redis nodes are healthy."
