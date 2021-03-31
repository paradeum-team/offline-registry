# offline-registry
offline-registry

##  创建线下源   

- 复制config.cfg.example 为config.cfg   
`cp config.cfg.example config.cfg`
- 根据实际情况修改配置内容

- 修改docker配置/etc/docker/daemon.json，加上一项insecure-registries
例如：
`cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "insecure-registries":["offlineregistry.offline-k8s.com:5000"]
}
EOF`  
- 增加域名解析    
`ip offlineregistry.offline-k8s.com`   

- 执行./enable.sh，启动本地registry  
- 编辑项目所需的imagelist，修改load_all_image.sh中的imagelist路径  
- 执行./load_all_image.sh 从线上pull镜像，再push到本地镜像仓库   
  注：若从线上pull镜像时，需要用到私有仓库，load_all_image.sh的用法为./load_all_image.sh true user password registryname
