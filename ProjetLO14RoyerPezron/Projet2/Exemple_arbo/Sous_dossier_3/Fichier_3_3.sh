awk '{ mots += NF; caracteres += length+1 } END { print NR, mots, caracteres, FILENAME }' $1

