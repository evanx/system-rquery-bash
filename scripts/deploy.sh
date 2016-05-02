
set -u -e 

rquery=${rquery:=https://clisecure.redishub.com}

echo rquery $rquery 

for host in $@
do 
  command="
    if [ ! -f .system-rquery-url ]
    then
      echo '$rquery' > .system-rquery-url
    fi
    echo -n '~/.system-rquery-url ' 
    cat .system-rquery-url
    crontab -l | grep system-rquery-bash
    if [ ! -d system-rquery-bash ] 
    then
      git clone https://github.com/evanx/system-rquery-bash
    fi
    cd system-rquery-bash && git pull
  "
  echo ssh $host "$command"
  ssh $host "$command"
done

