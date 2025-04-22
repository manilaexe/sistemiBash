#!/bin/bash

# Cambio current path
cd "$1" #entra nella directory passata come parametro

# Ripristino i file e conto le occorrenze
COUNTER=0
for i in `ls *.sh 2> /dev/null` #cicla sui file .sh nella dir | 2>.... serve per nascondere gli errori nel caso non ci fossero file .sh
do
     if test -f $i -a -r $i -a -w $i -a `grep -c "#!/bin/bash" $i` -gt 0
	#controlla: -f se il file è normale; -r se è leggibile; -w se è scrivibile; almeno una riga che contiene "#!/bin/bash" e grep -c le conta
     then #se tutto vero ->
         echo `pwd`/$i >> $LIST_FILE #redireziona l'output con il percorso del file dentro $LIST_FILE
         COUNTER=`expr $COUNTER + 1` #counter++
     fi
done

if test `cat $MAX_HIT` -lt $COUNTER #confronta il numero di script trovati (counter) con il numero massimo trovato fino ad ora (MAX_HIT)
then #se maggiore...
   echo $COUNTER > $MAX_HIT 
   echo `pwd` > $MAX_DIR #$MAX_HIT con il nuovo valore, e $MAX_DIR con la directory corrente.
fi

# Ricorsione
for dir in * #scorre tutto i lcontenuto della dir corrente
do
   if test -d "$dir" -a -x "$dir" #controlla: -d se è una dir; -x se è eseguibile 
   then
       trova_script_ric.sh "$dir" #richiama se stesso nella sotto dir
   fi
done
