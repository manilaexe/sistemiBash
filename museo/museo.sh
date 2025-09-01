#!/bin/bash
#ESAME DEL 25-06-2023

#controllo degli argomenti
if test $# -ne 2 #se non ho ESATTAMENTE 2 argomenti esco con errore
then 
    echo "$0: <esposizione> <anno>" #stampo come usare il programma
    exit 1
fi

esposizione=$1 #passo alla variabile esposizione il valore che ho nel terminale
anno=$2

#controllo che anno sia un path relativo
case $anno in
    /*) echo "errore: <anno> deve essere un path relativo" #controlla se anno inizia con /
        exit 2 #se inizia con / esce
        ;;
    *)  ;; #controlla che inizi con qualsiasi altra cosa
esac

#controllo che anno sia una directory
if test ! -d $anno #-d: verifica se il percorso indicato `e una directory (! nega) = "se non `e una dir"
then 
    echo "errore: <anno> deve essere una directory"
    exit 3
fi

#controllo di avere i permessi di esecuzione su anno
if test ! -x $anno
then
    echo "errore: non ho i permessi di esecuzione su <anno>"
    exit 4
fi

#aggiorno il path
#serve alla shell per sapere dove cercare museo_ric.sh
PATH=$PATH:`pwd`
export PATH 

#esporto il file di riepilogo delle opere
#mi serve per scriverci dentro le info su data e titolo dell'opera
OPERE=$HOME/esposizione.txt #assegna alla variabile Opere IL PERCORSO DEL FILE DI LOG 
export OPERE #rende la variabile visibile agli script figli

#creo il file di riepilogo delle opere
echo "" > $OPERE #scrive una stringa vuota nel file opere, se non esiste lo crea

#stampare a video il mese (con anche il .txt) in cui sono state sposte piu` opere
MAX=/tmp/MAX.tmp #contiene il numero massimo di opere in un singolo file
export MAX

MAX_FILE=/tmp/MAX_FILE.tmp #contiene il nome del file con il massimo numero di opere
export MAX_FILE

#creo il file per tener traccia del massimo numero di opere
echo "0" > $MAX #inizializzo il contatore a zero
echo "" > $MAX_FILE

#lancio la ricorsione
museo_ric.sh "$esposizione" "$anno" #la ricorsione ciclera` su tutti i .txt delle dir e sottodir
                                    #aggiorna $OPERE con data e titolo dell'esposizione
                                    #aggiorna anche $MAX e $MAX_FILE

#stampa e pulizia                                   
echo "numero massimo di opere: `cat $MAX_FILE`"
rm $MAX 
rm $MAX_FILE
