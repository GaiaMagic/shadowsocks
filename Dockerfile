FROM python:2.7.8

WORKDIR /ss

ADD . /ss

RUN python setup.py install

CMD ssserver \
	-m $METHOD \
	-p 443 \
	-c /ss/configs.json

EXPOSE 443
