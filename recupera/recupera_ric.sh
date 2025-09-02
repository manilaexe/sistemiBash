#!/bin/bash
#ESAME DEL 14-08-2020

dir=$1
recuperati=$2
titolo=$3

cd $dir

#ripristino i file e conto le occorrenze
COUNTER=0
for i in *.bak #per ogni file .bak nella directory corrente cicla
do 
    if test -f $i -a -r $i -a `head -n 1 $i | grep -c $titolo` -gt 0 #-f $i: controlla che i sia un file regolare
                                                              #-r $i: verifica che $i sia leggibile
                                                              #`head -n 1 $i`: prende solo la prima riga del file (grazie al -n 1)
                                                              #grep -c $titolo: (grep)cerca una stringa nel testo, -c non stampa le righe che contengono la stringa me le conta 
                                                              #-gt 0: confronta se e` maggiore di zero (titolo presente)
    then  
        cp "$i" "$recuperati" #copia il file corrente in $recuperati
        COUNTER=`expr $COUNTER + 1` #aggiorna il counter (in BASH per fare le operazioni e` necessario usare expr)
    fi
done

if test `cat $MAX_HIT` -lt $COUNTER #`cat $MAX_HIT`: legge il numero massimo di sile trovati fino ad ora
                                    #-lt: lessThan, controlla che il numero in $MAX_HIT sia minore di quello in $COUNTER
then 
    echo $COUNTER > $MAX_HIT #aggiorna MAX_HIT con counter
    echo `pwd` > $MAX_DIR #stampa la directory corrente
fi

TOT=`cat $TOTALE` #assegno a TOT il valore contenuto nel file tmp TOTALE 
echo `expr $TOT + $COUNTER` > $TOTALE #faccio la domma di TOT e del COUNTER e reindirizzo tutto nel file tmp TOTALE

#ricorsione
for d in * #guardo ogni cosa nella cartella dove mi trovo
do
    if test -d $d -a -x $d #controllo che d sia una cartella e che sia eseguibile
    then #se si parte la ricorsione
        $0 "$d" "$recuperati" "$titolo"
    fi
done 


