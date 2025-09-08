#!/bin/bash

#ESAME DEL 11-09-2024

#Programa per assistere il responsabile di una catena di cinema nella revisione delle vendite di biglietti per film di un certo genere durante un anno specifico.
#Interfaccia: cinema genere> <anno>
#Dove genere è una stringa alfanumerica e anno è un nome relativo di directory formato da soli caratteri numerici.
#Si supponga che le informazioni sulle vendite di biglietti nel corso dell'anno siano conservate all'interno della directory anno (o in una delle sue sottodirectory) in file di testo con estensione .txt (mese.txt).
#Ogni riga di tali file contiene, il numero di biglietti venduti, un identificativo univoco del film (ad esempio, B0001), l'identificativo del genere del film (Azione, Drammatico, ecc.) e il titolo del film.
#Lo script deve:
    #esplorare ricorsivamente la directory anno e tutte le sue sottodirectory per analizzare le informazioni presenti nei file .txt
    #selezionare esclusivamente le informazioni relative ai film del genere di interesse
    #estrarre le sole informazioni su numero di biglietti venduti e titolo e quindi scrivere tali dati in un file di log (riepilogo.log) nella home directory dell’utente (se il file gia` esiste e` da sovrascrivere)
    #Prima di terminare, lo script deve anche stampare a video il titolo del film per cui sono stati venduti più biglietti in un singolo mese.


#controllo degli argomenti
if test $# -ne 2
then
    echo "Uso: $0 <genere> <anno>"
    exit 1
fi

genere=$1
anno=$2

#controllo directory, percorso relativo
case $anno in
    /*)
        echo "$anno deve essere un percorso relativo"
        exit 2
        ;;
    *[!0-9]*)
        echo "La directory $anno deve essere composta da solo numeri (YYYY)"
        exit 3
    ;;
    *)
        if test ! -d $anno
        then 
            echo "$anno deve essere una directory"
            exit 4
        fi
        if test ! -x $anno
        then    
            echo "Non ho i permessi di esecuzione su $anno"
            exit 5
        fi;;

esac

PATH=$PATH:`pwd`
export PATH

LIST_FILM=$HOME/riepilogo.log
> "$LIST_FILM"
export LIST_FILM

MAX_HIT=/tmp/MAX_HIT.tmp
export MAX_HIT

MAX_TITOLO=/tmp/MAX_TITOLO.tmp
export MAX_TITOLO

echo "" > $MAX_TITOLO
echo 0 > $MAX_HIT

cinema_ric.sh "$genere" "$anno" 

echo "Titoli piu' venduti:" 
cat $MAX_TITOLO
