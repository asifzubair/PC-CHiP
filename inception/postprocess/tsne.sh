#!/bin/bash
bot=$1
outDir=$2
dim=$3

codebook=codebook.txt
codes=$(awk '{if($2=="meta"){$2="tumor"}; print $1"_"$2}' $codebook)

if [[ ! -s $bot.sub.10k ]]
then
    truncate -s 0  $bot.sub.10k
    for code in $codes
    do
	echo $code
	grep $code $bot | grep -v "thumbnail" |  awk '$4=="T"{print}' | shuf -n 10000  >> $bot.sub.10k
    done
shuf $bot.sub.10k > $bot.sub.10k.tmp
cut -d" " -f7-1542 $bot.sub.10k.tmp > $bot.sub.10k
cut -d" " -f1 $bot.sub.10k.tmp > $bot.sub.10k.id
rm $bot.sub.10k.tmp
fi

if [[ ! -s $outDir/tsne.$dim.txt ]]
then
    python tsneDir/bhtsne/bhtsne.py \
	-d=$dim \
	-i=$bot.sub.10k \
	-o=$outDir/tsne.$dim.txt \
	-m=10000  \
	-p=50
fi


    
