ls -l | awk 'NR>1 {tab[$4]+=$5} END{for (i in tab) print i, tab [i]}'


