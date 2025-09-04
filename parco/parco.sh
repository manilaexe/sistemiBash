#!/bin/bash

#ESAME 04-02-2025
#Programma per assistere un responsabile di un parco nella revisione delle osservazioni effettuare durante un certo anno
#Interfaccia: parco <specie> <anno>
#specie e` una stringa alfanumerica che identifica una tipologia di animale
#anno e` un nome relativo di directory di soli numeri YYYY
#Le informazioni sono in file di testo di nome mese.txt 
#Ogni riga del file e` composta da: identificativo univoco dell'osservazione, data (YYYYMMGG), identificativo della specie, luogo, nome osservatore
#Lo script deve:
    #Esplorare ricrosivamente anno e le sottodirectory, selezionare solo le informazioni relative alle osservazioni di una specie richiesta 
    #Selezionare solo tipo animale, data, luogo, nome osservatore e scriverle in osservazioni.txt nella home directory (se esiste gia` deve essere sovrascritto)
    #Stampare a video il mese dove sono state effettuate piu` esservazioni a prescindere dalla tipologia di animale

#controllo gli argomenti
if test $# -ne 2
then 
    echo "Uso: $0 <specie> <anno>"
    exit 1
fi

specie=$1
anno=$2

case $anno in  #controllo della cartella
    /*)
        echo "Errore: $anno deve essere un percorso relativo"
        exit 2;;
    *[!0-9]*)
        echo "Errore: il formato della cartella deve essere YYYY"
        exit 5;;
    *) if test ! -d $anno #deve essere una directory
        then
            echo "Errore: $anno deve essere una directory"
            exit 3
        fi
        if test ! -x $anno
        then   
            echo "Errore: non ho i permessi di esecuzione su $anno"
            exit 4
        fi ;;
esac

#aggiorno il PATH
PATH=$PATH:`pwd`
export PATH

MAX_HIT=/tmp/MAX_HIT.tmp
export MAX_HIT

MAX_MESE=/tmp/MAX_MESE.tmp
export MAX_MESE

LIST_OSS=/$HOME/osservazioni.txt
> "$LIST_OSS" #se non esiste lo crea, se esiste lo svuota
export LIST_OSS

echo 0 > $MAX_HIT
echo "" > $MAX_MESE

parco_ric.sh "$specie" "$anno"

echo "Mese dell'anno $anno con il maggior numero di osservazioni: `head -1 $MAX_MESE`"
