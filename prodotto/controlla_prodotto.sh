#!/bin/bash

#ESAME DEL 20-12-2019

#Programma per aiutare il responsabile di un’azienda a controllare la quantità dei prodotti presenti nei vari magazzini al fine di redigere l’inventario di fine anno.
#Interfaccia: controlla_prodotto <dir> <nome_prodotto>
#Dove dir e` un path assoluto e nome_prodotto è una stringa rappresentante un nome di un prodotto venduto dall’azienda
#Le informazioni sono salvate in file di testo (es. bologna.txt) che si trovano all’interno della directory dir o in una delle sue sottocartelle.
#Ciascuna riga di tali file conterrà le informazioni relative a una singola tipologia di prodotto presente nel magazzino, con: nome prodotto, nome produttore, paese di provenienza, quantitàstoccata, peso, collocazione, data di produzione ecc.
#Lo script deve:
    #esplorare ricorsivamente la directory dir e tutte le sottodirectory
    #selezionare le informazioni relative al prodotto di interesse, estrarre la sola informazione sulla quantità disponibile e sommarla a quella presente negli altri magazzini.
    #Il dato complessivo e il nome del prodotto devono essere aggiunti in modalitàappend a un file di risultati, con il nome di “inventario_2019.txt”, posizionato all’interno della home directory dell’utente.
    #Prima di terminare, il file comandi deve anche stampare a video il nome del magazzino in cui èpresente la maggior quantitàdel prodotto di interesse tra tutti i magazzini analizzati.

if test $# -ne 2
then
    echo "Uso: $0 <dir> <nome_prodotto>"
    exit 1
fi

dir=$1
prod=$2

case $dir in
    /*)
        if test ! -d "$dir" 
        then 
            echo "$dir deve essere una directory"
            exit 2
        fi
        if test ! -x "$dir"
        then
            echo "Non ho i permessi di esecuzione su $dir"
            exit 3
        fi ;;
    *)
        echo "$dir deve essere un percorso assoluto"
        exit 4;;
esac

PATH=$PATH:`pwd`
export PATH

MAX_HIT=/tmp/MAX_HIT.tmp
export MAX_HIT

MAX_MAG=/tmp/MAX_MAG.tmp
export MAX_MAG

ADD=/tmp/ADD.tmp
export ADD

LIST=$HOME/inventario_2019.txt 
export LIST

echo "" > $MAX_MAG
echo 0 > $MAX_HIT
echo 0 > $ADD

controlla_prodotto_ric.sh "$dir" "$prod" 

echo "$prod - `tail "$ADD"`" >> $LIST

echo "Magazzino con maggior quantita di $prod `cat $MAX_MAG`"
