#!/bin/bash
#ESAME 05-07-2023

#Programma per aiutare il manager di una catena di ristoranti a consultare gli ordini effettuati per un determinato piatto durante un anno specifico.
#Interfaccia: ristorante <piatto> <anno>
#Dove piatto e` una stringa e anno un nome assoluto di directory
#Si supponga che le informazioni sugli ordini effettuati nel corso dell'anno siano memorizzate all'interno della directory anno (o in una delle sue sottodirectory) in file di testo con estensione .log (DDMM.log)
#Ciascuna riga di tali file conterrà le informazioni relative a un ordine: l’identificativo univoco del piatto, il nome del piatto e il timestamp (formato YYYYMMDDHHMM) (un piatto può essere ordinato più volte nell’arco di una giornata)
#Lo script ristorante deve:
    #esplorare ricorsivamente la directory anno e tutte le sue sottodirectory
    #selezionare esclusivamente le informazioni relative agli ordini del piatto di interesse
    #estrarre le (sole) informazioni sul timestamp, e quindi scrivere tali dati in un file di log (chiamato piatto.log) nella home directory
    #se il file di log esiste già, lo script deve sovrascriverne il contenuto.
    #Prima di terminare, il file comandi deve stampare a video il contenuto del file di riepilogo piatto.log e il giorno (ovverosia il nome del file corrispondente) in cui il piatto di interesse è stato ordinato più volte.

if test $# -ne 2
then 
    echo "Uso: $0 <piatto> <anno>"
    exit 1
fi

piatto=$1
anno=$2

case $anno in
    /*) if test ! -d "$anno"
        then 
            echo "$anno deve essere una directory"
            exit 2
        fi
        if test ! -x "$anno"
        then 
            echo "Non ho i permessi di esecuzione su $anno"
            exit 3
        fi;;
    *)
        echo "$anno deve essere un percorso assoluto"
        exit 4;;
    *[!0-9]) 
        echo "Il formato della directory deve essere (YYYY)"
        exit 5;;    
esac 

PATH=$PATH:`pwd`
export PATH

MAX_HIT=/tmp/MAX_HIT.tmp
export MAX_HIT

MAX_DAY=/tmp/MAX_DAY.tmp
export MAX_DAY

LIST_MAX=$HOME/piatto.log
> "$LIST_MAX"
export LIST_MAX

echo 0 > $MAX_HIT
echo "" > $MAX_DAY

ristorante_ric.sh "$piatto" "$anno"

echo "Giorno con il maggior numero di richieste di $piatto: `head -1 "$MAX_DAY"`"
echo "File piatto.txt:" 
cat "$LIST_MAX"
