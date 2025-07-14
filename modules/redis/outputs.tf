output "redis_endpoint" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes[0].address
  description = "Redis primary endpoint address"
}

output "redis_port" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes[0].port
  description = "Redis port"
}
