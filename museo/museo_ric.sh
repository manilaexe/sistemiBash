#!/bin/bash
#ESAME DEL 25-06-2023

#assegno a delle variabili i parametri che gli ho passato da museo.sh
esposizione=$1
dir=$2

#entra nella directory 
cd $dir

for f in *txt #per tutti i file con estensione .txt. f avra ogni volta il nome di un file diverso
do 
    #controllo che <f> sia un file e di avere i permessi di lettura
    if test -f $f -a -r $f #-f $f: controlla che $f esista e che sia un file
                           #-a: AND logico
                           #-r $f: controlla se il file e` leggibile
    then 
        grep $esposizione $f | cut -d, -f1,3 >> $OPERE #$esposizione $f: cerca tutte le righe del file $f che contengono il codice dell'esposizione
                                                       #|: passa l'output del comando come input del comando successivo (prende l'out del grep e lo manda al cut)
                                                       #cut -d, -f1,3: seleziona solo il primo ed il terzo camop della riga del file (il separatore e` la virgola -d,)
                                                       # >> $OPERE: aggiunge queste righe al file di riepilogo $OPERE
        #aggiorno il massimo
        val=`wc -l < $f` #wc: WordCount, con aggiunta di -l conta le righe di un file dato in input dopo il < (in questo caso $f)
                         #assegna il tutto ad una variabile val
        if test $val -gt `cat $MAX` #$val: numero di righe del file corrente
                                    #-gt: GreaterThan, confronta i numeri
                                    #`cat $MAX` numero massimo di righe trovato fino ad ora letto dal file $MAX
        then #esegue se il file corrente ha piu` righe di quello massimo memorizzato fino ad ora
            echo $val > $MAX #aggiorna $MAX con il massimo effettivamente trovato
            echo $f > $MAX_FILE #aggiorna $MAX_FILE con il nome del file che contiene il numero massimo di righe
        fi
    fi
done


#lancio della ricorsione
for d in * #prende tutti i file e le cartelle nella dir corrente
do
    if test -d "$d" -a -x "$d" #-d "$d": verifica se d e` una directory
                               #-a: AND logico
                               #-x "$d": verifica se la directory e` eseguibile/visibile
    then 
        museo_ric.sh "$esposizione" "$d"
    fi
done
