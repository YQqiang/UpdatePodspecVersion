#!/bin/sh
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 配置
podSources=(http://app.sungrow.cn:3000/iOS/SGSpecs.git
            https://github.com/CocoaPods/Specs.git)
swiftVersion=4.2
specs=SGSpecs

# 目录
pathCurrent=$(pwd)
echo ${pathCurrent}

# 获取podspec路径
extensionPodspec='podspec'
namePodspec=`ls ${pathCurrent} | grep "\.${extensionPodspec}"`
pathPodspec=${pathCurrent}/${namePodspec}
echo ${pathPodspec}

# 获取旧版本号
oldVersionLine=`nl ${pathPodspec} | sed -n '/.version /p'`

array=(${oldVersionLine//=/ })

arrayCount=${#array[*]}

oldVersionPre=${array[arrayCount-1]}

oldVersionLength=${#oldVersionPre}

oldVersion=${oldVersionPre:1:oldVersionLength-2}

echo "旧版本号: ${oldVersion}"

# 版本号自增
increment_version ()
{
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1

  for (( CNTR=${#part[@]}-1; CNTR>=0; CNTR-=1 )); do
    len=${#part[CNTR]}
    new=$((part[CNTR]+carry))
    [ ${#new} -gt $len ] && carry=1 || carry=0
    [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
  done
  new="${part[*]}"
  echo "${new// /.}"
}

# 自增后的新版本号
newVersion=`increment_version ${oldVersion}`
echo "新版本号: ${newVersion}"

# 拼接 pod 资源路径
sources=''
for i in ${podSources[@]};do
    if [${sources} == '']
    then
        sources=${i}
    else
        sources="${sources},${i}"
    fi
done

# pod lint
pod lib lint --sources=${sources} --allow-warnings --verbose --no-clean --swift-version=${swiftVersion}

# 更改版本号
sed -i '' "s/${oldVersion}/${newVersion}/g" ${pathPodspec}

# 提交变更内容
git add ${pathPodspec}

git commit -m "update podspec version ${newVersion}"

git pull

git push

# 新增 tag
git tag ${newVersion}

git push --tags

# pod push
pod repo push ${specs} --sources=${sources} --allow-warnings --verbose




