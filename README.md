# UpdatePodspecVersion
update podspec version

cocoapods 私有库自动更新脚本

# 使用步骤

1. 配置 
    * podSources  
        私有库spec仓库地址
        
    * specs 
        .cocoapods/repos/[REPO]

2. `updatePodspec.sh` 放在 `*.podspec` 文件的同级目录下

3. 执行

    ```
    ./updatePodspec.sh
    ```
    
# 脚本执行逻辑

1. 获取podspec路径
2. 获取旧版本号
3. 版本号自增
4. pod lib lint
5. 更改版本号
6. 提交变更内容
7. 新增 tag
8. pod repo push

