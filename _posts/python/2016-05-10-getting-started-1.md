---
layout: post
title:  "Getting started with Django - 1"
date:   2016-05-10
categories: python
tags:
- python
- django
---

* content
{:toc}

Django를 깊이 파보기에 앞서 일단 무작정 `HelloWorld`라는 Django 프로젝트를 하나 생성하고 이를 웹 서버를 이용해 실행해보도록 하겠다

## Django를 시작하기 앞서...
Django의 프로젝트의 구조를 설명하기 앞서 Django 프레임워크에서 사용되는 `프로젝트(Project)`와 `어플리케이션(Application)`의 용어의 의미를 짚고 넘어가도록 하겠다.

> Django에서 `프로젝트(Project)`는 **개발대상이 되는 전체 프로그램**을<br/>
> 그리고 `어플리케이션(Application)`은 **프로젝트 하위의 서브 프로그램**을 의미

하나의 `프로젝트`에서 여러 기능을 `어플리케이션` 단위로 모듈화를 할 수 있다는 의미인 것 같은데 이렇게 되면 하나의 `어플리케이션`을 여러 프로젝트에서 재사용 할 수 있으니 개발 생산성 및 모듈화 측면에서 장점이 있는 듯 하다.

또한 여러 `어플리케이션`을 모아 `프로젝트`를 구성하고 또 `프로젝트`를 모아 더 큰 `프로젝트`를 구성하는 방법으로 **계층적 웹 프로그램 개발**이 가능하다고 하는데 사실 아직 이부분은 크게 와닿지는 않아 이렇게만 알고 넘어가도록 하겠다.

## 프로젝트 생성

{% highlight bash %}
$ django-admin.py startproject HelloWorld
{% endhighlight %}

위의 명령어를 이용해 `HelloWorld` 프로젝트를 생성한다.<br/>
위의 명령어를 실행하면 HelloWorld라는 프로젝트 폴더가 만들어지고 하위 폴더로 HelloWorld라는 똑 같은 폴더가 하나 더 만들어지는데 상위 폴더는 프로젝트 폴더, 하위 폴더에는 프로젝트 관련 설정 파일들이 들어있다.

## 어플리케이션 생성

{% highlight bash %}
$ python manage.py startapp application_one
{% endhighlight %}

프로젝트를 생성 했으니 `application_one`이라는 어플리케이션을 생성해보자.<br/>
위의 명령어를 실행하면 HelloWorld 프로젝트내에 application_one이라는 어플리케이션이 하나 생성되고 그 안에 어플리케이션 관련 파일들이 생성되게 된다.

## 데이터베이스 변경사항 반영

{% highlight bash %}
$ python manage.py migrate
Operations to perform:
  Synchronize unmigrated apps: staticfiles, messages
  Apply all migrations: admin, contenttypes, auth, sessions
Synchronizing apps without migrations:
  Creating tables...
    Running deferred SQL...
  Installing custom SQL...
Running migrations:
  Rendering model states... DONE
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying sessions.0001_initial... OK
{% endhighlight %}

위의 명령어를 실행시키면 **데이터베이스의 변경 사항을 반영하는 작업**을 수행한다.<br/>
하지만 나는 아직 어플리케이션 모델도 구성하지 않았고 데이터베이스도 만들지 않았다. 그렇다면 왜 이런 단계가 필요한걸까?

Django는 기본적으로 모든 웹 프로젝트 개발 시 반드시 `사용자와 사용자의 그룹 테이블`이 필요하다고 가정하고 설계되었다고 한다.
따라서 따로 테이블을 생성하지 않았다고 하더라도 `migrate`를 이용해 `사용자 및 사용자 그룹 테이블`을 만들어주기 위해 프로젝트 개발 시작 시점에 이 명령어를 실행한다.

`settings.py`내에 따로 데이터베이스 연동 설정을 건드리지 않았기 때문에 기본 설정인 `Sqlite` 데이터가 생성된다.

![Django Sqlite](/post_images/django_sqlite.png)

Sqlite 툴을 이용해 생성된 데이터 파일을 로드한 그림이다.<br/>
좌측에 사용자 및 사용자 그룹 관련 여러 테이블이 생성된 것을 볼 수 있다.

## 웹 서버 실행

{% highlight bash %}
$ python manage.py runserver
erforming system checks...

System check identified no issues (0 silenced).
May 10, 2016 - 10:23:04
Django version 1.8.11, using settings 'HelloWorld.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
[10/May/2016 10:23:11] "GET / HTTP/1.1" 200 1767
{% endhighlight %}

`runserver`를 이용해 지금까지 생성한 `HelloWorld` 프로젝트를 웹 서버에 올릴 수 있다.<br/>
`http://127.0.0.1:8000`이 현재 띄워져 있는 웹 서버의 주소이다.

## 웹 브라우저 실행

![Django Web Server](/post_images/django_runserver.png)

웹 브라우저를 통해 접속한 모습이다.

*출처: 본 내용은 `Django로 배우는 쉽고 빠른 웹 개발 - 파이썬 웹프로그래밍`을 정리한 내용입니다*