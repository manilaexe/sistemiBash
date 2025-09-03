#!/bin/bash

#ESAME 16-06-2020

#Programma che aiuta nella ricerca di file di script
#Interfaccia: trova_script <dir>
#dir e` un nome assoluto di directory
#Cerca in modo ricorsivo in dir tutti i file con estensione .sh, leggibili e scrivibili e con all'interno la stringa !#/bin/bash
#I nome dei file che soddisfano i requisiti vengono salvati su un file script.txt nella home dir, se non esiste va creato
#Al temine viene scritto a video il nome della sottodirectory con il maggior numero di file che soddisfano i requisiti

dir=$1
COUNTER=0

#cambio del path
cd $dir

for f in *.sh #per ogni file che finisce con .sh
do 
    if test "$f" = "*.sh"
    then
        continue
    fi

    if test -f $f -a -r $f -a -w $f #se e` un file E e` leggibile E e` scrivibile E contiene la stringa #!/bin/bash
    then
        if test `grep -c "#!/bin/bash" $f` -gt 0 
        then
            echo `pwd`/$f >> $LIST_FILE #scrive il nome del file nel LIST_FILE
            COUNTER=`expr $COUNTER + 1` #aggiorna il counter
        fi
    fi
done

if test `cat $MAX_HIT` -lt $COUNTER #guarda se esiste un nuovo massimo
then #se esiste:
    echo $COUNTER > $MAX_HIT #nuovo massimo
    echo `pwd` > $MAX_DIR #nuova directory con il massimo
fi

#ricorsione
for d in * #per ogni cosa in nella cartela guardo se: 
do 
    if test -d $d -a -x $d #se e` una cartela E se e` eseguibile
    then #se si parte la ricorsione   
        $0 "$d" 
    fi
done
