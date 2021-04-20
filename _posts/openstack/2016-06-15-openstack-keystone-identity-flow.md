---
layout: post
title:  "[OpenStack] Keystone's Identity Flow"
date:   2016-06-13
categories: openstack
tags:
- openstack
---

* content
{:toc}

## Overview
`OpenStack` 내에 있는 각각의 서비스(Nova, Neutron, Cinder, Glance 등등)을 사용하려면 `Keystone 인증(Identity)과정`을 거쳐야 한다.
이번 포스팅에서는 `Keystone`을 이용한 `OpenStack의 인증 절차`를 정리하고자 한다.

## Keystone이란?
`Keystone`이란 `OpenStack`에서 `인증관리를 담당하는 서비스`이다. 모든 `OpenStack`의 서비스들은 이 `Keystone`을 이용하여 인증 절차를 거친다.


### Keystone의 주요 용어
- Authentication: 사용자의 신원(Identity)를 확인하기 위한 프로세스
- Credentials: 사용자의 신원(Identity)을 확인하기 위한 데이터 (ex. user name and password, user name and API key ...)
- Domain (Identity service API v3): 신원 객체(Identity Entities)들을 관리하기 위해 관리적인 측면에서 바운더리를 정의해 놓은 사용자(User)들과 프로젝트(Project)들의 집합 
개인, 회사 운영자 자신의 공간을 나타낼 수도 있다. Domain 관리자는 해당 Domain 내에서 프로젝트(Project) 및 사용자(User), 그룹(Group)을 생성할 수 있고 사용자(User) 및 그룹(Group)에 역할(Role)을 부여할 수도 있다.
- Endpoint: OpenStack 서비스에 연결할 수 있는 접속가능한 주소
- Group (Identity service API v3): 특정 Domain에 속해있는 사용자(User)들의 집합. 그룹에 대해 역할(Role)을 지정할 수 있다.
- OpenStackClient: Identity API를 포함한 OpenStack 서비스의 커맨드라인 인터페이스(CLI)
- Project: 그룹(Group) 혹은 격리된 자원 또는 신원 객체(Identity Object)들의 컨테이너, 서비스 운영자에 의존적일 수 있으 고객 계정 조직 또는 테넌트(Tenant)에 맵핑될 수 있다.
- Region (Identity service API v3): 일반적으로 분할된 OpenStack 배포 환경을 나타낸다. AWS의 US East, US West, EU, Asia Pacific(Seoul) 등의 Region을 같은 의미
- Role: 사용자(User)에게 개별적으로 부여되는 역할(Role). (ex. admin, member ...)
- Service: 사용자가 접근할 수 있고 사용할 수 있는 하나 또는 그 이상의 엔드포인트(Endpoint)를 제공하는 OpenStack 서비스
- Token: OpenStack API 및 자원에 접근 할 수 있게 하는 알파벳과 숫자가 조합된 문자열
- User: OpenStack 클라우드 서비스를 사용하는 사용자, 시스템 혹은 서비스

## Keystone의 인증 절차

간단하게 `Keystone`개념 및 용어를 짚어 봤으니 이제 `Keystone`의 인증 절차를 알아보겠다.

아래의 그림은 `Keystone`을 이용해 클라이언트가 인증과정을 거처 `OpenStack Service API`를 사용하기 까지의 간략한 흐름이다.

![OpenStack Keystone Token Validation Flow](/post_images/openstack_keystone_token_validation_flow.png)

1) `클라이언트`는 `사용자(User)`의 신원 정보가 담긴 `Credential`정보와 함께 `Keystone`에게 `Token` 생성 요청을 한다.

{% highlight json %}
POST /v2.0/tokens HTTP/1.1
Host: CLOUD_DOMAIN:5000
Content-Type: application/json
Cache-Control: no-cache

{
   "auth":{
      "passwordCredentials":{
         "username":"USER_ID",
         "password":"USER_PASSWORD"
      }
   }
}
{% endhighlight %}

2) `Keystone`은 같이 들어온 `Credential` 정보를 바탕으로 요청한 `사용자(User)`의 신원을 확인하고 맞을 시 아래와 같은 `Token(UUID)`을 내려준다.

{% highlight json %}
{
  "access": {
    "token": {
      "issued_at": "2016-06-16T02:00:42.000000Z",
      "expires": "2016-06-16T03:00:42.190880Z",
      "id": "gAAAAABXYghKfbCVLEkp8ti6xV7dRScTesScQLXMAq0MKlSghrM7jXRxduZ-Dzr15qpgTPMDXqPhx3f0qGlEGemd5BFGBPpDr2GIfqB1omqSvqi5fnTS0aC9qyH_5f4u3SLskOBqo4kZmpA-6kjX7s3MbIwaF8iYTw",
      "audit_ids": [
        "d8OV1fN7QJGYeqyIIbHgpA"
      ]
    },
    "serviceCatalog": [],
    "user": {
      "username": "wkjeon",
      "roles_links": [],
      "name": "USER_ID",
      "roles": [],
      "id": "46f27d3321ff4016ad7fd6a07ad4d364",
      "enabled": true,
      "email": "USER_EMAIL"
    },
    "metadata": {
      "is_admin": 0,
      "roles": []
    }
  }
}
{% endhighlight %}

3) 이제 `클라이언트`는 `Keystone`으로부터 받은 `Token(UUID)`을 `캐싱`하고 이를 통해 `OpenStack Service API`에 접근한다.

4) `클라이언트`가 `Token(UUID)`과 함께 `OpenStack Service API`에 요청을 하며 해당 `OpenStack Service`는 요청으로부터 `Token(UUID)`을 추출해 내고 이를 `Keystone`에 유효한 `Token(UUID)`값인지 확인하는 과정을 거친다.

5) `Keystone`으로부터 응답을 받으면 각각의 `OpenStack API Service`들은 결과에 따라 요청한 클라이언트들에게 상황에 맞는 응답을 내려주게된다.

