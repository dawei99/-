#!/bin/bash
# ------------------------------#
# 查找没有引入的php文件移出项目 #
# ----------------------------- #

fileDir='/home/rjh/www/kunming_water/limspro/webpage'  # 需要查找哪些文件
pruneDir=("/home/rjh/www/kunming_water/limspro/webpage/vendor" "/home/rjh/www/kunming_water/limspro/webpage/api/vendor" "/home/rjh/www/kunming_water/limspro/webpage/runtime" "/home/rjh/www/kunming_water/limspro/webpage/upload") # 需要排除的目录
fileExt='php' # 需查找文件后缀名
findDir=('/home/rjh/www/kunming_water/limspro/ngpage' '/home/rjh/www/kunming_water/limspro/webpage')  # 在哪些目录查找
bakDir='/home/rjh/www/kunming_water/findBak' # 无用文件存放位置


pruneDirTurn=${pruneDir[@]}
pruneDirString=${pruneDirTurn// /' -o -path '}
if [ -n "$pruneDirString" ] ; then pruneDirString="( -path ${pruneDirString} ) -prune -o " ; else echo pruneDirString=''; fi
declare -A pathMap=()
for realFile in `find ${fileDir} ${pruneDirString} -name '*.php' -type f`
do
    realFileDir=`dirname $realFile` # 绝对路径目录
    fileName=`echo ${realFile} | grep -Po "\/\w+\.${fileExt}" | grep -Po "\w+.php"` # 相对路径

    findRes=0 # 查找结果
    # 开始查找
    for targetDir in ${findDir[@]} ; do
        grep -rnF "$fileName" $targetDir &> /dev/null
        if [ $? -eq 0 ] ; then
            findRes=1
            break
        fi
    done
    if [ $findRes -eq 0 ] ; then
        echo "备份文件${realFile}"
        mkdir -p ${bakDir}${realFileDir}
        mv $realFile ${bakDir}${realFile}
    fi
done
