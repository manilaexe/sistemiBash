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

if test $# -ne 2
then
    echo "Uso: $0 <veicolo> <anno>"
    exit 1
fi

veicolo=$1
anno=$2

case $anno in
    /*)
        echo "$anno deve essere un percorso relativo di directory"
        exit 2;;

    *[!0-9]*)
        echo "Il formato della directory deve essere (YYYY)"
        exit 3;;
    *)
        if test ! -d "$anno" 
        then 
            echo "$anno deve essere una directory"
            exit 4
        fi
        if test ! -x "$anno"
        then     
            echo "Non ho i permessi di esecuzione su $anno"
            exit 5
        fi;;

esac

PATH=$PATH:`pwd`
export PATH

MAX_HIT=/tmp/MAX_HIT.tmp
export MAX_HIT

MAX_MESE=/tmp/MAX_MESE.tmp
export MAX_MESE

LIST=$HOME/output.txt
> "$LIST"
export LIST

echo "" > $MAX_MESE
echo 0 > $MAX_HIT

azienda_ric.sh "$veicolo" "$anno"

echo "Mese con il maggior numero di viaggi: `cat "$MAX_MESE"`" 
