shadowsocks
===========

```
cd shadowsocks
echo '{"password": "FOOOOOOOOOOOO", "workers": 2}' > configs.json
docker-compose build
docker-compose up -d
```

### Bandwidth limit

Use this command to generate crontab tasks to prevent shadowsocks
from hogging the network in working hours (9AM - 6PM):

```
./limit.sh
```
