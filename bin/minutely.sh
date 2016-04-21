
set -u -e 

hour=`date +%H`
minute=`date +%M`

echo hour $hour
echo minute $minute
echo hourlyMinute $hourlyMinute
echo dailyHour $dailyHour 

c2hset() {
  serviceUrl='https://redishub.com/rquery'
  keyspace=$USER
  key=host:`hostname -s`
  url=$serviceUrl/ks/$keyspace/hset/key/$1/$2?quiet
  echo url $url 
  curl -s $url | python -mjson.tool
}

c0minutely() {
  c2hset diskspace `df -h | grep '/$' | sed 's/\s\s*/ /g' | cut -d' ' -f5 | sed 's/\W//g'`
  c2hset cpuload `cat /proc/loadavg | cut -d' ' -f1`
  if which redis-cli >/dev/null && redis-cli info | grep -q '^used_memory:[0-9]*$'
  then
    c2hset redismegs `redis-cli info | grep '^used_memory:' | cut -d':' -f2`
  fi

}

c0hourly() {
  c0minutely
}

c0daily() {
  c0minutely
}


c0cron() {
  if [ -n "$hourlyMinute" -a $minute -eq "$hourlyMinute" ] 
  then
    if [ -n "$dailyHour" -a $hour -eq "$dailyHour" ] 
    then
      c0daily
    else
      c0hourly
    fi
  else
    c0minutely
  fi
}

if [ $# -ge 1 ]
then
  command=$1
  shift
  c$#$command
else
  echo "usage: command e.g. cron"
fi



