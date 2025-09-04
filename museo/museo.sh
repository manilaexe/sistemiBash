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

#controllo degli argomenti
if test $# -ne 2 #se non ho ESATTAMENTE 2 argomenti esco con errore
then 
    echo "$0: <esposizione> <anno>" #stampo come usare il programma
    exit 1
fi

esposizione=$1 #passo alla variabile esposizione il valore che ho nel terminale
anno=$2

#controllo che anno sia un path relativo
case $anno in
    /*) echo "errore: <anno> deve essere un path relativo" #controlla se anno inizia con /
        exit 2 #se inizia con / esce
        ;;
    *)  ;; #controlla che inizi con qualsiasi altra cosa
esac

#controllo che anno sia una directory
if test ! -d $anno #-d: verifica se il percorso indicato `e una directory (! nega) = "se non `e una dir"
then 
    echo "errore: <anno> deve essere una directory"
    exit 3
fi

#controllo di avere i permessi di esecuzione su anno
if test ! -x $anno
then
    echo "errore: non ho i permessi di esecuzione su <anno>"
    exit 4
fi

#aggiorno il path
#serve alla shell per sapere dove cercare museo_ric.sh
PATH=$PATH:`pwd`
export PATH 

#esporto il file di riepilogo delle opere
#mi serve per scriverci dentro le info su data e titolo dell'opera
OPERE=$HOME/esposizione.txt #assegna alla variabile Opere IL PERCORSO DEL FILE DI LOG 
export OPERE #rende la variabile visibile agli script figli

#creo il file di riepilogo delle opere
echo "" > $OPERE #scrive una stringa vuota nel file opere, se non esiste lo crea

#stampare a video il mese (con anche il .txt) in cui sono state sposte piu` opere
MAX=/tmp/MAX.tmp #contiene il numero massimo di opere in un singolo file
export MAX

MAX_FILE=/tmp/MAX_FILE.tmp #contiene il nome del file con il massimo numero di opere
export MAX_FILE

#creo il file per tener traccia del massimo numero di opere
echo "0" > $MAX #inizializzo il contatore a zero
echo "" > $MAX_FILE

#lancio la ricorsione
museo_ric.sh "$esposizione" "$anno" #la ricorsione ciclera` su tutti i .txt delle dir e sottodir
                                    #aggiorna $OPERE con data e titolo dell'esposizione
                                    #aggiorna anche $MAX e $MAX_FILE

#stampa e pulizia                                   
echo "numero massimo di opere: `cat $MAX_FILE`"
rm $MAX 
rm $MAX_FILE
