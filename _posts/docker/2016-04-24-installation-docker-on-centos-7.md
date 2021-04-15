---
layout: post
title:  "Installation docker on CentOS 7"
date:   2016-04-23
categories: docker
tags: docker
---

* content
{:toc}

## CentOS 6

### EPEL Repository 추가
{% highlight bash %}
rpm -iUvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
{% endhighlight %}


### YUM 업데이트
{% highlight bash %}
sudo yum update -y
{% endhighlight %}

### 패키지 설치
{% highlight bash %}
sudo yum -y install docker-io
{% endhighlight %}

### Docker 서비스 실행

{% highlight bash %}
sudo service docker start
{% endhighlight %}

### 부팅 시 자동 시작되도록 등록

{% highlight bash %}
sudo chkconfig docker on
{% endhighlight %}

## CentOS 7

### 패키지 설치

{% highlight bash %}
sudo yum -y update
sudo yum -y install docker
{% endhighlight %}

### Docker 서비스 실행

{% highlight bash %}
sudo systemctl start docker
{% endhighlight %}

### 부팅 시 자동 시작되도록 등록

{% highlight bash %}
sudo systemctl enable docker
{% endhighlight %}
_* CentOS7부터 chfconfig가 아닌 systemctl enable {서비스명}으로 변경_

