#!/bin/bash
#ESAME DEL 25-06-2023
#Programma per aiutare il curatore di un museo a consultare le opere esposte per una determinata esposizione durante un anno specifico. 
#Interfaccia: museo <esposizione> <anno>
#Dove esposizione e` un stringa alfanumerica che identifica univocamente una certa esposizione organizzata dal museo
#E anno e` un nome relativo di directory formato da soli caratteri numerici.
#Si supponga che le informazioni sulle opere esposte nel corso dell'anno siano memorizzate all'interno della directory anno (o in una delle sue sottodirectory) in file di testo con estensione .txt.
#Ciascuna riga di tali file conterrà le informazioni relative a un’opera esposta in una certa esposizione con, in quest’ordine, la data di inizio dell’esposizione (nel formato AAAAMMGG), l’identificativo univoco dell’esposizione (E412, BA39, etc.), il titolo dell’opera e l'artista.
#Lo script deve: 
    #esplorare ricorsivamente la directory anno e tutte le sottodirectory per analizzare le informazioni presenti nei file .txt
    #selezionare esclusivamente le informazioni relative alle opere dell’esposizione di interesse ed estrarre le (sole) informazioni su data e titolo e quindi scrivere tali dati in un file di log nella home directory
    #Se il file di log esiste già, lo script deve sovrascriverne il contenuto
    #Prima di terminare, deve stampare a video il mese (il nome del file corrispondente, comprensivo di suffisso .txt) in cui sono state esposte più opere


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
