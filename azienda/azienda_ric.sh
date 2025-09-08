#!/bin/bash

#ESAME DEL 13-06-2024

#Programma per assistere il direttore di un'azienda di trasporti nella revisione dei viaggi effettuati durante un anno specifico.
#Interfaccia: azienda <veicolo> <anno>
#Dove veicolo è una stringa alfanumerica che identifica univocamente un tipo di veicolo e anno è un nome relativo di directory formato da soli caratteri numerici.
#Le informazioni sui viaggi effettuati nel corso dell'anno sono conservate all'interno della directory anno (o in una delle sue sottodirectory) in file .txt (mese.txt)
#Ogni riga del file contiene le informazioni relative a un viaggio: identificativo univoco del viaggio (es, T0001), data del viaggio (YYYYMMGG), l'identificativo univoco del tipo di veicolo (Autobus, Camion, ecc.), la destinazione e il nome dell'autista.
#Lo script deve: 
    #esplorare ricorsivamente la directory anno e tutte le sue sottodirectory
    #selezionare esclusivamente le informazioni relative ai viaggi della tipologia di veicolo di interese
    #estrarre le sole informazioni su data, destinazione e nome dell’autista
    #scrivere tali dati in un file di log (chiamato output.txt) nella home directory dell’utente.
    #Se il file di log esiste già, lo script deve sovrascriverne il contenuto.
    #stampare a video il mese in cui sono stati effettuati più viaggi, inteso come file che ha il maggior numero di righe (a prescindere dalla tipologia di veicolo specificato).

veicolo=$1
anno=$2
COUNTER=0

cd $anno

for f in *.txt
do
    if test -f "$f" -a -r "$f"
    then
        COUNTER=$(wc -l < "$f") #conta tutte le righe del file
        if test `cat "$MAX_HIT"` -lt "$COUNTER" #se il file corrente ha piu` righe di quello precedente allora sostituisce con i parametri correnti quelli vecchi
        then   
            echo $COUNTER > $MAX_HIT
            echo "${f%.txt}" > $MAX_MESE
        fi
        if test `grep -c "$veicolo" "$f"` -gt 0
        then
            grep "$veicolo" "$f" | cut -d "," -f2,4,5 >> "$LIST"
        fi
    fi
done

for d in *
do 
    if test -d "$d" -a -x "$d"
    then
        azienda_ric.sh "$veicolo" "$d"
    fi
done
