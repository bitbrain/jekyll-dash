---
layout: post
title:  "[OpenStack] Horizon Horizon Project Front-end Structure"
date:   2016-07-08
categories: openstack
tags:
- openstack
---

* content
{:toc}

## Overview
이번 포스팅에서는 앞의 포스팅에서 이야기한데로 `Horizon`의 `프론트-엔드 아키텍처`정리한다.<br/><br/>
`Horizon 프론트-엔드`에서는 `AngularJS`와 `BootStrap`을 쓰고 있지만 대부분의 뷰를 `Django Template`에서 구성하고 있고 화면단에서 이루어지는 대부분의 리퀘스트를 `a.href` 및 `form submit`을 이용해 처리하고 있기 때문에 사실상 프론트-엔드의 역할이 그리 크지는 않다.
해서 화면에서의 POST 액션처리만 정리한다.

![Horizon POST Action Flow](/post_images/openstack_horizon_post_action_flow.png)
