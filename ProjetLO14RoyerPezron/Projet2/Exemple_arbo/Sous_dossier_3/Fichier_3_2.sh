awk 'NR==1 {print} NR>1 {n=split($5,tab,"/"); if (tab[n]%2==0) print}' #n est le nombre d'element du tableau
