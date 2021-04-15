---
layout: post
title:  "IP Masquerade"
date:   2016-05-12
categories: network
tags:
- network
---

* content
{:toc}

## 개요

네트워크 용어 중에 `Masquerade`이라는 용어가 있다.<br/>
어제 포스팅한 `dnsmasq`의 masq도 이 `Masquerade`의 약어인데 그냥 그런가보다하고 넘어가면 나중에 까먹어비릴거 같아 간단히 정리한다.

`IP Masquerade`는 일종의 `NAT(Network Address Traslation)`과 같은 기능이다.<br/>
공인 IP 주소를 가지고 있는 1대의 `IP Masquerade 호스트`를 통해 같은 네트워크 상의 공인 IP를 할당받지 못한 호스트들이 인터넷에 연결할 수 있도록 하는 기능이다.

다시 말해 `IP Masquerade`를 이용하면 공인 IP를 가지고 있는 `IP Masquerade 호스트`를 통해 다른 호스트들도 공인 IP 없이 인터넷에 접속할 수 있게된다. `IP Masquerade 호스트`의 IP를 마치 자신의 IP 인양 사용하게 된다.

여기까지만 보면 `SNAT`와 동일한 기능으로 보이지만 둘 사이에 어떤 차이점을 보이는지는 아직 잘 모르겠다.

![IP Masquerade](/post_images/ip_masquerade.png)