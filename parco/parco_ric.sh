#!/bin/bash

#ESAME 04-02-2025
#Programma per assistere un responsabile di un parco nella revisione delle osservazioni effettuare durante un certo anno
#Interfaccia: parco <specie> <anno>
#specie e` una stringa alfanumerica che identifica una tipologia di animale
#anno e` un nome relativo di directory di soli numeri YYYY
#Le informazioni sono in file di testo di nome mese.txt 
#Ogni riga del file e` composta da: identificativo univoco dell'osservazione, data (YYYYMMGG), identificativo della specie, luogo, nome osservatore
#Lo script deve:
    #Esplorare ricorsivamente anno e le sottodirectory, selezionare solo le informazioni relative alle osservazioni di una specie richiesta 
    #Selezionare solo tipo animale, data, luogo, nome osservatore e scriverle in osservazioni.txt nella home directory (se esiste gia` deve essere sovrascritto)
    #Stampare a video il mese dove sono state effettuate piu` esservazioni a prescindere dalla tipologia di animale


specie=$1
dir=$2
COUNTER=0

cd $dir

for f in *.txt #per ogni file .txt
do
    if test -f "$f" -a -r "$f"  #guarda i permessi
    then 
        COUNTER=`wc -l < "$f"` #assegna al counter il numero di righe del file
        if test `cat $MAX_HIT` -lt "$COUNTER"  #confronta il MAX_HIT con il counter attuale
        then #se il counter e` maggiore
            echo $COUNTER > $MAX_HIT #sostituisce con il nu9ovo valore del counter
            echo "${f%.txt}" > $MAX_MESE #scrive in MAX_MESE il nuovo nome del file con il numero massimo di osservazioni
        fi
        if test `grep -c "$specie" "$f"` -gt 0 #guarda se esiste una segnalazione della specie data
        then #se esiste
            grep "$specie" "$f" | cut -d "," -f2,3,4,5 >> "$LIST_OSS" #scrive i campi richiesti nel file osservazioni.txt
        fi
    fi
done

#avvio ricorsione
for d in *
do
    if test -d "$d" -a -x "$d"
    then
        parco_ric.sh "$specie" "$d"
    fi
done
