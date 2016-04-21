
set -u -e 

keyspace=${keyspace:=$USER}

if ! crontab -l | grep -q 'system-rquery-bash'
then
  echo "Paste the following into crontab i.e. /var/spool/cron/$USER" 
  echo "* * * * * keyspace=$keyspace hourlyMinute=0 dailyHour=0 ~/system-rquery-bash/bin/minutely.sh cron >> ~/tmp/cron.rquery.log 2>&1" 
fi 



