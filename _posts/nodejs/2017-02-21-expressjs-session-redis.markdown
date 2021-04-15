---
layout: post
title:  "[Nodejs] Node.js에서 Redis를 이용한 세션 관리"
date:   2017-02-21
categories: nodejs
tags:
- nodejs
- expressjs
- redis
- session
---

* content
{:toc}

## Overview
지금 개발하고 있는 **Node.js** 프로젝트에서 **Redis**를 이용해 **세션관리**를 구현해야할 필요성이 생겨 관련 내용을 정리한다.

## 구현
```js
var session = require('express-session');
var cookieParser = require('cookie-parser');
var redis = require('redis');

var redisHost = 'localhost';
var redisPort = 6379;
var client = redis.createClient(redisPort, redisHost);

var RedisStore = require('connect-redis')(session);

app.use(cookieParser());
app.use(session({
    secret: 'your_secret_string',
    resave: false,
    store: new RedisStore({host: redisHost, port: redisPort, client: client}),
    saveUninitialized: true
}));
```
