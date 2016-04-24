
set -u -e 

hour=`date +%H`
minute=`date +%M`

rquery=${rquery:=`cat ~/.system-rquery-url`}
keyspace=${keyspace:=$USER}
hostKey=host:`hostname -s`
hourlyMinute=${hourlyMinute:=0}
dailyHour=${dailyHour:=0}
timeString=`date -Iseconds`
hostHashNumber=`hostname -s | md5sum | sed 's/[^0-9]//g'`
hostDelay=`echo $hostHashNumber % 55 | bc`

echo hour $hour
echo minute $minute
echo hourlyMinute $hourlyMinute
echo dailyHour $dailyHour 
echo rquery $rquery
echo keyspace $keyspace
echo hostKey $hostKey
echo hostDelay $hostDelay 
echo timeString $timeString

c1curl() {
  url=$rquery/$1
  echo url $url 
  curl -s -k $url | python -mjson.tool
}

c1curlq() {
  c1curl $1?quiet
}

c1curlp() {
  c1curl $1?nplain
}

c0state() {
  c1curl keys
  c1curl hgetall/$hostKey
}

c2hset() {
  c1curlp hset/$hostKey/$1/$2
}

c0minutely() {
  c1curl sadd/hosts/`hostname -s`
  c2hset hour $hour
  c2hset minute $minute
  c2hset diskspace `df -h | grep '/$' | sed 's/\s\s*/ /g' | cut -d' ' -f5 | sed 's/\W//g'`
  c2hset loadavg `cat /proc/loadavg | cut -d' ' -f1`
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
  echo "sleep $hostDelay"
  sleep $hostDelay
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



