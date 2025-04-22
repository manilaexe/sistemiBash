#!/bin/bash
#file che lancia il ricorsivo
if test $# -ne 1 #controlla se è stato passato ESATTAMENTE UN ARGOMENTO
then
	echo "Errore: uso $0 <dir>"
	exit 1
fi

case $1 in
      /*) if test ! -d "$1" -o ! -x "$1" #Se l'argomento è un path assoluto (cioè inizia con /) allora controlla se non è una directory oppure se non è accessibile
          then
            echo $1 non è una directory o non si hanno i diritti di accesso
            exit 2
          fi;;
      *) echo $1 non è un path assoluto
         exit 3;;
esac

LIST_FILE=$HOME/script.txt; export LIST_FILE #crea una variabile dd'ambiente chhe contiene il percorso si script.txt nella home
					     #export rende la variabile visibile anhce ai processi figli (lo script ricorsivo)
touch $LIST_FILE #Crea il file script.txt se non esiste, oppure aggiorna la data di modifica se esiste già.

PATH=$PATH:`pwd` #aggiunge la dir corrente al path
export PATH

MAX_DIR=/tmp/.maxDir #Crea una variabile chiamata MAX_DIR, che punta a un file temporaneo /tmp/.maxDir
export MAX_DIR #visibile allo ricorsivo 
> $MAX_DIRscript #lo inizializza (crea e svuota il file).

MAX_HIT=/tmp/.maxHit; export MAX_HIT; echo 0 > $MAX_HIT

trova_script_ric.sh "$1"

echo La directory contenente il maggior numero di script è `cat $MAX_DIR` con `cat $MAX_HIT` occorrenze totali.

rm $MAX_DIR
rm $MAX_HIT
