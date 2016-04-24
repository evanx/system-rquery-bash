
## system-rquery-bash

Push system metrics into a Redis-based "rquery" instance via the cron.

Currently only diskpace and load average are pushed, for illustration:
```shell
  hset diskspace $diskspace
  hset cpu $loadavg
```
where these metrics are determined using `df` and `/proc/loadavg`

which saves these metrics in an online Redis service, viz. `https://redishub.com/rquery` by default.

The intended purpose is for custom monitoring and alerting. However that functionality will be provided by other microservices, i.e. to aggregate and monitor the metrics of all hosts pushed by this service.


#### rquery

See my Node HTTP Redis service: https://github.com/evanx/rquery

This service is deployed for public use at: https://redishub.com


### Status

UNSTABLE


### Implementation

See: https://github.com/evanx/system-rquery-bash/bin


### Installation

```shell
git clone https://github.com/evanx/system-rquery-bash
```

### Usage

You can add this to your crontab as follows:
```shell
rquery=http://redishub.com/rquery/$keyspace/$rtoken
* * * * * hourlyMinute=0 dailyHour=0 ~/system-rquery-bash/bin/minutely.sh cron >> ~/tmp/cron.rquery.log 2>&1
```
where you must substitute your chosen `keyspace` and its access `token.` Otherwise by default the `rquery` URL is read from `~/.system-rquery-url`

For example, a `token` is generated via: 
```shell
curl -s https://cli.redishub.com/rquery/gentoken
```
where this is a 10 byte random number encoded in Base32.

Then your chosen keyspace is registered via: 
```shell
curl -s https://cli.redishub.com/rquery/kt/$keyspace/$token/register/github.com/$ghuser
```
where we specify our Github username.

Note that the `keyspace` is globally unique, and so you should prefix it e.g. with your Github username.

You can check your keyspace:
```shell
rquery=`cat ~/.system-rquery-url`
curl -s $rquery/keys 
```
```json
hosts
host:eowyn
host:faramir
```
and a specific host:
```shell
curl -s $rquery/hgetall/host:`hostname -s` | python -mjson.tool
```

```json
loadavg=1.23
diskspace=19
```

### Related

See my Node HTTP Redis service: https://github.com/evanx/rquery

Related projects and further plans: https://github.com/evanx/mpush-redis/blob/master/related.md

