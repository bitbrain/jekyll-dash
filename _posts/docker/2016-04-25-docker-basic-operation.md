---
layout: post
title:  "Docker Basic Commands"
date:   2016-04-25
categories: docker
tags:
- docker
---

* content
{:toc}

## 이미지 검색
{% highlight bash %}
sudo docker search {keyword}
{% endhighlight %}

## 이미지 다운로드
{% highlight bash %}
sudo docker pull {image_name}:{tag}
{% endhighlight %}

## 컨테이너 생성
{% highlight bash %}
sudo docker run {options} {image_name} {command}
{% endhighlight %}
### 주요 옵션
* --name: 컨테이너 이름 정의
* -i: 컨테이너의 STDIN을 Grap함으로서 Interaction 연결을 생성하는 것을 허용
* -t: 컨테이너내에서 pseudo-tty or terminal을 할당

## 컨테이너 목록 확인
{% highlight bash %}
sudo docker ps -a
{% endhighlight %}

## 컨테이너 접속
{% highlight bash %}
sudo docker attach {container_name_or_id}
{% endhighlight %}
