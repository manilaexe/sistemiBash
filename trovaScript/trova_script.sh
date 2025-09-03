#!/bin/bash

#ESAME 16-06-2020

#Programma che aiuta nella ricerca di file di script
#Interfaccia: trova_script <dir>
#dir e` un nome assoluto di directory
#Cerca in modo ricorsivo in dir tutti i file con estensione .sh, leggibili e scrivibili e con all'interno la stringa !#/bin/bash
#I nome dei file che soddisfano i requisiti vengono salvati su un file script.txt nella home dir, se non esiste va creato
#Al temine viene scritto a video il nome della sottodirectory con il maggior numero di file che soddisfano i requisiti

#controllo gli argomenti
if test $# -ne 1 #l'argomento deve essere solo uno
then
    echo "Uso: $0 <dir>";
    exit 1
fi

dir=$1

case $dir in
    /*) if test ! -d $dir #controllo che dir sia affettivamente una directory
        then   
            echo "$dir deve essere una directory"
            exit 2
        fi
        if test ! -x $dir #controllo di avere i permessi di esecuzione
        then   
            echo "non ho i permessi di esecuzione su $dir"
            exit 3
        fi;;
    *) echo "$dir deve essere un path assoluto" #controllo che sia un path assoluto
        exit 4;;
esac

#esporto il PATH
PATH=$PATH:`pwd`
export PATH

#file dove scrivere i nomi dei file .sh
LIST_FILE=$HOME/script.txt
export LIST_FILE
touch $LIST_FILE #se non esiste crea il file vuoto, se esiste gia` aggiorna la data di modifica senza cancellare il contenuto

#variabile per il nome della sottodirectory con il maggior numero di file che soddisfano i requisiti
MAX_DIR=/tmp/MAX_DIR.tmp
export MAX_DIR

MAX_HIT=/tmp/MAX_HIT.tmp #questa mi serve per tenere il conto
export MAX_HIT

echo ""> $MAX_DIR
echo 0 > $MAX_HIT

trova_script_ric.sh "$dir"

echo "Sottodirectory con il maggior numero di files che soffisfano i requisiti: `cat $MAX_DIR`"
