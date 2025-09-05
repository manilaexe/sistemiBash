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

piatto=$1
anno=$2
COUNTER=0

cd $anno

for f in *.log
do
    if test -f "$f" -a -r "$f"
    then   
        COUNTER=$(grep -c "$piatto" "$f")
        if test `grep -c "$piatto" $f` -gt 0 
        then
            grep "$piatto" "$f" | cut -d "," -f3 >> "$LIST_MAX"
            COUNTER=`expr $COUNTER + 1`
        fi
        
        if test `cat "$MAX_HIT"` -lt "$COUNTER"
        then    
            echo $COUNTER > $MAX_HIT
            echo $f > $MAX_DAY
        fi
    fi
done

for d in *
do
    if test -d "$d" -a -x "$d"
    then
        ristorante_ric.sh "$piatto" "$d"
    fi
done
