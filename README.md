# offline-registry
offline-registry

##  创建线下源   

- 复制config.cfg.example 为config.cfg   
`cp config.cfg.example config.cfg`
- 根据实际情况修改配置内容

- 修改docker配置/etc/docker/daemon.json，加上一项insecure-registries
例如：
`cat /etc/docker/daemon.json    
{"insecure-registries":["offlineregistry.offline-okd.com:5000"]}`

- 执行./enable.sh，启动本地registry  
- 编辑项目所需的imagelist，修改load_all_image.sh中的imagelist路径
- 执行./load_all_image.sh 从线上pull镜像，再push到本地镜像仓库
