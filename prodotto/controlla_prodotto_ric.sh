#!/bin/bash

#ESAME DEL 20-12-2019

#Programma per aiutare il responsabile di un’azienda a controllare la quantità dei prodotti presenti nei vari magazzini al fine di redigere l’inventario di fine anno.
#Interfaccia: controlla_prodotto <dir> <nome_prodotto>
#Dove dir e` un path assoluto e nome_prodotto èuna stringa rappresentante un nome di un prodotto venduto dall’azienda
#Le informazioni sono salvate in file di testo (es. bologna.txt) che si trovano all’interno della directory dir o in una delle sue sottocartelle.
#Ciascuna riga di tali file conterrà le informazioni relative a una singola tipologia di prodotto presente nel magazzino, con: nome prodotto, nome produttore, paese di provenienza, quantitàstoccata, peso, collocazione, data di produzione ecc.
#Lo script deve:
    #esplorare ricorsivamente la directory dir e tutte le sottodirectory
    #selezionare le informazioni relative al prodotto di interesse, estrarre la sola informazione sulla quantità disponibile e sommarla a quella presente negli altri magazzini.
    #Il dato complessivo e il nome del prodotto devono essere aggiunti in modalità append a un file di risultati, con il nome di “inventario_2019.txt”, posizionato all’interno della home directory dell’utente.
    #Prima di terminare, il file comandi deve anche stampare a video il nome del magazzino in cui è presente la maggior quantità del prodotto di interesse tra tutti i magazzini analizzati.

dir=$1
prod=$2

cd $dir

for f in *.txt
do 
    if test -f "$f" -a -r "$f"
    then 
        COUNTER=0
        if test `grep -c "$prod" "$f"` -gt 0
        then
            for q in `grep "$prod" "$f" | cut -d "," -f4`
            do
                COUNTER=`expr $COUNTER + $q`
            done
            tot=$(expr $COUNTER + $(cat "$ADD"))
            echo $tot > $ADD 
            if test `cat $MAX_HIT` -lt $COUNTER
            then    
                echo $COUNTER > $MAX_HIT
                echo "${f%.txt}" > $MAX_MAG
            fi 
        fi
    fi
done

for d in *
do 
    if test -d "$d" -a -x "$d"
    then    
        controlla_prodotto_ric.sh "$d" "$prod"
    fi
done
