# 获取 Maven 项目打包结果
# -r : Maven 项目的根目录地址
# -g : Maven 项目的 groupId 
# -v : Maven 项目的 版本 
# Usage: ./collectjar.sh -r /app/workspaces/canal-canal-1.1.4 -g com.alibaba.otter -v 1.1.4
#
#
# Get command line params

while getopts ":r:g:v:" opt; do
	case $opt in
		r) rootDir="$OPTARG"
		;;
		g) groupId="$OPTARG"
		;;
		v) version="$OPTARG"
		;;
	esac
done


groupIdPath=${groupId//./\/}
mkdir -p $groupIdPath

for pomPath in `find $rootDir -name pom.xml`
do
    artDir=${pomPath/pom.xml/target/}

    # if the target dir not exist continue
    if [ ! -d $artDir ] ;then continue; fi

    # copy pom.xm to *.pom
    jarFile=`find $artDir -maxdepth 1 -type f -not -name 'original-*.jar' -name '*.jar' | head -n 1`
    jarName=${jarFile##*/}
    jarArtId=${jarName%%-${version}*}
    artPath=$groupIdPath/$jarArtId/$version
    mkdir -p $artPath
    cp $pomPath $artPath/$jarArtId-$version.pom
    echo "copy [$pomPath]  to  [$artPath/$jarArtId-$version.pom]"
		
    # copy jar files 
    for jarFile in `find $artDir -maxdepth 1 -name *.jar`
    do
        jarName=${jarFile##*/}
        cp -f $jarFile $artPath
        echo "copy [$jarFile]  to  ["`pwd`"/$artPath/$jarName]"
    done
done
