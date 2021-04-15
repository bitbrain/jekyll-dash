---
layout: post
title:  "Django's MTV Pattern"
date:   2016-05-10
categories: python
tags:
- python
- django
---

* content
{:toc}

## 개요

Django에서는 MTV(Model-Template-View)패턴을 사용하는데 사실 그 안을 들여다보면 기존 MVC 모델과 동일하다.
다만 Django에서는 **MVC 모델에서의 View를 Template, Controller를 View**라고 명명한다

정리하자면...<br/>

`Model: 데이터베이스에 저장되는 데이터`<br/>
`Template: 사용자에게 보여지는 부분`<br/>
`View: 실질적인 비즈니스 로직`<br/>

이렇게 정리할 수 있는데 이해하기 쉽게 그림으로 보면 아래와 같다.

![Django MVT](/post_images/django_mvt.png)

*출처: 본 내용은 `Django로 배우는 쉽고 빠른 웹 개발 - 파이썬 웹프로그래밍`을 정리한 내용입니다*