---
layout: post
title:  "Getting started with Django - 2"
date:   2016-05-10
categories: python
tags:
- python
- django
---

* content
{:toc}

## 관리자 사이트

Django는 웹 서버의 컨텐츠(데이터베이스)에 대한 관리 기능을 위해 프로젝트를 시작하는 시점에 기본 기능으로 `관리자 사이트`를 제공한다. 이 관리자 화면을 통해서 어플리케이션에서 사용하는 데이터들을 쉽게 관리할 수 있다.

`http://127.0.0.1:8000/admin`와 같이 앞서 브라우저에 띄운 주소 뒤에 `/admin`을 붙어 아래와 같이 관리자 사이트에 접속한다.

![Django Admin Login](/post_images/django_admin.png)

## 관리자(슈퍼 유저) 생성

관리자 사이트에 접속하면 위의 그림과 같이 로그인창이 로딩되게 되는데 나는 아직 관리자 계정을 생성하지 않았다.

따라서 아래와 같이 관리자 사이트 접속을 위한 관리자(슈퍼유저) 계정을 생성해보도록 하겠다.

{% highlight bash %}
$ python manage.py createsuperuser
Username (leave blank to use 'jeremyjeon'): nicejeremy
Email address: woogri83@gmail.com
Password:
Password (again):
Superuser created successfully.
{% endhighlight %}


## 관리자 사이트 로그인

위에서 생성한 정보를 바탕으로 관리자 페이지를 로그인하면 아래와 같이 데이터를 관리할 수 있는 관리 화면으로 이동하게 된다.

![Django Admin Dashboard](/post_images/django_admin_dashboard.png)

위의 스크린샷을 보면 이미 `Users`와 `Groups` 테이블이 생성되어 있는 것을 확인할 수 있는데 이는 이미 `settings.py` 파일에 `django.contrib.auth` 어플리케이션이 `INSTALLED_APPS` 항목에 등록되어 있기 때문이다.


## 마치며

이로써 프로젝트를 생성하는 것 부터 관리자 사이트에 접속하는 것 까지 기본적인 한 사이클을 마쳤다. 앞으로는 실제 파일럿 프로젝트를 Django 프레임워크 기반으로 진행하면서 필요한 내용들을 기록할 예정이다.


*출처: 본 내용은 `Django로 배우는 쉽고 빠른 웹 개발 - 파이썬 웹프로그래밍`을 정리한 내용입니다*