
set -u -e 

hour=`date +%H`
minute=`date +%M`

serviceUrl=${serviceUrl:='https://redishub.com/rquery'}
keyspace=${keyspace:="$USER"}
hostKey=host:`hostname -s`
hourlyMinute=${hourlyMinute:=0}
dailyHour=${dailyHour:=0}

echo hour $hour
echo minute $minute
echo hourlyMinute $hourlyMinute
echo dailyHour $dailyHour 
echo serviceUrl $serviceUrl
echo keyspace $keyspace
echo hostKey $hostKey

c1curl() {
  url=$serviceUrl/ks/$keyspace/$1?quiet
  echo url $url 
  curl -s $url | python -mjson.tool
}

c0state() {
  c1curl keys
  c1curl hgetall/$hostKey
}

c2hset() {
  c1curl hset/$hostKey/$1/$2
}

c0minutely() {
  c1curl sadd/hosts/`hostname -s`
  c2hset hour $hour
  c2hset minute $minute
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
  if [ -n "$hourlyMinute" -a $hourlyMinute -gt 0 -a $minute -eq "$hourlyMinute" ] 
  then
    if [ -n "$dailyHour" -a $dailyHour -gt 0 -a $hour -eq "$dailyHour" ] 
    then
      c0daily
    else
      c0hourly
    fi
  else
    c0minutely
  fi
  c0state
}

if [ $# -ge 1 ]
then
  command=$1
  shift
  c$#$command
else
  echo "usage: command e.g. cron"
fi



