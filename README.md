shadowsocks
===========

```
cd shadowsocks
echo '{"password": "FOOOOOOOOOOOO", "method": "aes-256-cfb", "workers": 2}' > configs.json
docker-compose build
docker-compose up -d
```
