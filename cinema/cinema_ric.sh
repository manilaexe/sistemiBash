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

genere=$1
anno=$2
COUNTER=0

cd $anno

for f in *.txt
do 
    if test -f "$f" -a -r "$f"
    then 
        if test `grep -c "$genere" "$f"` -gt 0
        then 
            grep "$genere" "$f" | cut -d "," -f1,4 >> "$LIST_FILM"
            max_biglietti=$(grep "$genere" "$f" | sort -t, -k1 -nr | head -1)
            # estraiamo i valori
            biglietti=$(echo $max_biglietti | cut -d "," -f1)
            titolo=$(echo $max_biglietti | cut -d "," -f4)

            # aggiorniamo il massimo globale se necessario
            if test "$biglietti" -gt `cat "$MAX_HIT"`
            then
                echo "$biglietti" > "$MAX_HIT"
                echo "$titolo" > "$MAX_TITOLO"
            fi
        fi
    fi
done



for d in *
do 
    if test -d "$d" -a -x "$d"
    then    
        cinema_ric.sh "$genere" "$d"
    fi
done
