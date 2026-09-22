set $(date)

case $1 in
	lun.)jour=lundi;;
	mar.)jour=mardi;;
	mer.)jour=mercredi;;
	jeu.)jour=mercredi;;
	ven.)jour=vendredi;;
	sam.)jour=samedi;;
	dim.)dimanche;;
esac

case $3 in
	jan.)mois=Janvier;;
	oct.)mois=Octobre;;
esac

echo $jour $2 $mois $4 à $5
