FROM node:6

RUN mkdir /app && npm install -g truffle
ADD . /app
RUN ls -l / && ls -l /app && cd /app && npm install

WORKDIR /app