#!/bin/bash
#ESAME DEL 14-08-2020
#ATTENZIONE: stampa anche head: impossibile aprire '*.bak' per la lettura: File o directory non esistente ma non so cosa farci (non ne ho voglia)

#Programma che aiuti a recuperare documenti di testo  erroneamente cancellati. 
#Interfaccia: recupera <dir> <recuperati> <titolo>
#Dove: dir e recuperati sono nomi assoluti di directory e titolo e` una stringa di testo che  l’utente sa essere il titolo del documento, presente sulla prima riga all’interno del file.  
#Il file comandi si basa sull’assunzione che ciascun file sia stato duplicato all’interno della  stessa directory del file originale col suffisso aggiuntivo “.bak”. 
#Il file comandi deve: 
    #esplorare in modo ricorsivo la directory dir per cercare tutti i file  leggibili dall’utente il cui nome termini con “.bak” e che all’interno contengano la stringa  titolo nella prima riga
    #Tali file devono essere copiati nella directory recuperati. Se la  directory recuperati non esiste, deve essere creata.  
    #Al termine delle operazioni, il file comandi scrive a video il nome della sottodirectory che  contiene il maggior numero di file recuperati e anche il numero totale di file recuperati.

#controllo degli argomenti
if test $# -ne 3 #controllo che gli elemento passati siasno esattamente 3
then 
    echo "!errore! $0: <dir> <recuperati> <titolo>"
    exit 1
fi

dir=$1
recuperati=$2
titolo=$3

#controllo che dir sia un path assoluto
case $dir in
    /*) if test ! -d $dir #controllo che dir sia una directory
        then 
            echo "$dir deve essere una directory"
            exit 2
        fi
        if test ! -x $dir #controllo che dir sia eseguibile
        then 
            echo "errore: non ho i permessi di esecuzione su $dir"
            exit 3
        fi;;
    *) echo "$dir deve essere un path assoluto"
        exit 4;;
esac

#controllo che recuperati sia un path assoluto
case $recuperati in
    /*);; #se inizia con '/' vuol dire che e` gia` un path assoluto e allora non fa nulla
    *) echo "$recuperati deve essere un path assoluto" 
        exit 7;;
esac

#controllo che la directory recuperati esista
if test ! -d $recuperati
then
    mkdir $recuperati
fi

#aggiorno il path 
PATH=$PATH:`pwd` #! attenzione a NON mettere lo spazio tra : e `pwd`
export PATH

#creo lae variabili che mi servono
MAX_DIR=/tmp/MAX_DIR.tmp #contiene il nome della sottocartella con il numero maggiore di file recuperati
export MAX_DIR 

MAX_HIT=/tmp/MAX_HIT.tmp #contiene il numero totale dei file recuperati
export MAX_HIT

TOTALE=/tmp/TOTALE.tmp #contiene il totale dei file ripristinati
export TOTALE

#inizializzo le variabili
echo "" > $MAX_DIR
echo "0" > $MAX_HIT
echo "0" > $TOTALE

#lancio la ricorsione
recupera_ric.sh "$dir" "$recuperati" "$titolo"

echo "Directory con il maggior numero di file rispistinati: $(head -1 $MAX_DIR)" #tutto quello che sta dentro $() viene eseguito come comando 
                                                                                 #e` l'equivalente di `head -1 $MAX_DIR` ma con una sintassi piu` moderna
                                                                                 # head -1: legge solo la prima riga del file

echo "Numero totale di file ripristinati: $(cat $MAX_HIT)" #legge tutto il contenuto del file stampandolo poi a video 
