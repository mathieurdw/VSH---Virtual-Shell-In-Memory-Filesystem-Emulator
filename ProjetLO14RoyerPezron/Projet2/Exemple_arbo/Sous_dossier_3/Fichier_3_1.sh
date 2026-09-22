while read mot; do
	taille=${#mot}
	if [[  ! $1 =~ ^[0-9]+$ ]];then
		exit
	fi
	if [ $1 -eq $taille ];then
		flag=1
		for i in ${@:2};do
			if [[ ! $i =~ ^[a-z][0-9]$ ]];then
				exit
			fi
			lettre=${i:0:1}
			pos=$(echo $i | cut -c2)
			char=$(echo $mot | cut -c$pos)
			#char=${mot:$pos:1}
			if [ $lettre != $char ];then
				flag=0
			fi		
		done
		if [ $flag -eq 1 ];then
			echo $mot
		fi	
	fi
done< words
