
touch splitList

while read p; do
    suffix=$(echo $p | awk '{print $1}')
    echo $suffix
    cat "splitList.${suffix}" >> splitList
done <genome.fa.fai
