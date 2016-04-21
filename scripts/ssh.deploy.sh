
set -u -e 

for host in $@
do 
  ssh $host '
    if [ ! -d system-rquery-bash ] 
    then
      git clone https://github.com/evanx/system-rquery-bash
    fi
    cd system-rquery-bash && git pull
  ' 
done

