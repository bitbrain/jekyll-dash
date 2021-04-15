---
layout: post
title:  "[OpenStack] Cinder Backup to Swift in OpenStack"
date:   2016-06-13
categories: openstack
tags:
- openstack
- cinder
- backup
- swift
---

* content
{:toc}

## Overview
`OpenStack` 프로젝트 중 `Cinder`는 `볼륨(Volume)`에 대한 관리를 담당하는 프로젝트이다. 이번 포스팅에서는 **생성된 Cinder 볼륨을 Swift에 백업(Backup)하는 방법** 설명한다. 참고로 `Swift`는 OpenStack의 Object Storage에 대한 프로젝트이다. AWS의 S3 서비스와 같다고 생각하면 된다.

## Cinder내의 백업 드라이버 변경
우선 Cinder 설정 파일 내의 `백업 드라이버(backup_deriver` 설정을 아래와 같이 `Swift`를 바라보도록 설정해야 한다.

{% highlight bash %}
backup_driver=cinder.backup.drivers.swift
{% endhighlight %}

백업 드라이버 변경 후 `cinder-backup`서비스를 재시작해준다

{% highlight bash %}
$ service cinder-backup restart
cinder-backup stop/waiting
cinder-backup start/running, process 19473
{% endhighlight %}

이제 `Swift`로의 백업을 위한 기본적인 설정은 모두 끝났다.

## 볼륨 백업 (Volume Backup)
`Cinder`에서는 다음의 3가지의 백업 방식을 지원한다.

> snapshot: 볼륨에 대한 스냅샷 이미지<br/>
> cgsnapshot: Consistency Group에 대한 스냅샷 이미지<br/>
> backup: 볼륨에 대한 백업

`스냅샷(snapshot)`은 볼륨의 현재 상태에 대해 사진을 찍는다고 생각하면된다. `Cinder`에서는 이 스냅샷 기능을 이용해 특정 시점에 특정 볼륨을 이미지화 시키는 기능을 제공해주는데 사실 백업이라기 보다는 일종의 볼륨 템플릿을 뜬다는 개념이 강하다. 실제로 `Cinder` 스냅샷을 이용해 할 수 있는 기능에는 복원 같은 기능이 포함되어 있지 않고 스냅샷을 이용한 인스턴스 생성과 같은 기능을 사용할 수 있다.

`cgsnapshot`은 아직 정확히 어떤 기능인지 개념이 잡히지 않아 이번 포스팅에서는 생략하도록 하겠다.

마지막으로 `backup` 기능이 실제로 우리에게 익숙한 백업 생성 및 복원과 같은 백업 기능을 제공하고 있다. 그리고 또 다시 아래와 같은 두 가지 백업타입을 제공해주고 있다. 

### 1. Full Backup (전체 백업)
말 그대로 `전체 백업`을 의미한다. 특정 볼륨의 전체를 백업을 시켜버린다.

아래는 `Cinder`를 이용한 백업 커맨드의 사용법이다.

{% highlight bash %}
$ cinder help backup-create
usage: cinder backup-create [--container <container>] [--name <name>]
                            [--description <description>] [--incremental]
                            [--force]
                            <volume>

Creates a volume backup.

Positional arguments:
  <volume>              Name or ID of volume to backup.

Optional arguments:
  --container <container>
                        Backup container name. Default=None.
  --name <name>         Backup name. Default=None.
  --description <description>
                        Backup description. Default=None.
  --incremental         Incremental backup. Default=False.
  --force               Allows or disallows backup of a volume when the volume
                        is attached to an instance. If set to True, backs up
                        the volume whether its status is "available" or "in-
                        use". The backup of an "in-use" volume means your data
                        is crash consistent. Default=False.
{% endhighlight %}

아래는 실제로 특정 볼륨의 백업을 생성하는 예제이다. 

{% highlight bash %}
$ cinder backup-create 3731b3c2-0b5f-4a54-beb9-82a7d7b74e8e --container 'Cinder-Backup' --name 'Initial Backup for CentOS 7' --force
+-----------+--------------------------------------+
|  Property |                Value                 |
+-----------+--------------------------------------+
|     id    | 23c651a3-7958-4cf9-8587-c21feebcbdb6 |
|    name   |     Initial Backup for CentOS 7      |
| volume_id | 3731b3c2-0b5f-4a54-beb9-82a7d7b74e8e |
+-----------+--------------------------------------+

$ cinder backup-show 23c651a3-7958-4cf9-8587-c21feebcbdb6
  
+-----------------------+--------------------------------------+
|        Property       |                Value                 |
+-----------------------+--------------------------------------+
|   availability_zone   |                 nova                 |
|       container       |            Cinder-Backup             |
|       created_at      |      2016-06-13T05:04:04.000000      |
|      description      |                 None                 |
|      fail_reason      |                 None                 |
| has_dependent_backups |                False                 |
|           id          | 23c651a3-7958-4cf9-8587-c21feebcbdb6 |
|     is_incremental    |                False                 |
|          name         |     Initial Backup for CentOS 7      |
|      object_count     |                 821                  |
|          size         |                  40                  |
|         status        |               creating               |
|       volume_id       | 3731b3c2-0b5f-4a54-beb9-82a7d7b74e8e |
+-----------------------+--------------------------------------+
{% endhighlight %}

`in-use` 상태의 볼륨에 대해 백업을 수행할 때는 `--force` 옵션이 추가되어야 한다.
백업이 완료되면 `status` 속성이 `available`로 바뀐다.

또한 `증분 백업`을 수행하기 위해서는 백업을 수행하기 위한 볼륨에 대해 최초 1번은 `전체 백업`이 이루어져야 이후 `증분 백업`을 진행할 수 있다.

### 2. Incremental Backup (증분 백업)
`증분 백업`은 이전의 백업본과 비교하여 변경된 내용만 백업하는 것을 의미한다.

아래는 `증분 백업`을 생성하는 예제이다.
해당 볼륨에서 `apt-get`을 이용해 `git`을 설치한 후 `증분 백업`을 수행했다.

{% highlight bash %}
$ cinder backup-create 3731b3c2-0b5f-4a54-beb9-82a7d7b74e8e --container 'Cinder-Backup' --name 'Backup with git' --force --incremental
+-----------+--------------------------------------+
|  Property |                Value                 |
+-----------+--------------------------------------+
|     id    | 98c50a79-4e04-40c8-8168-9ff6695c4b39 |
|    name   |           Backup with git            |
| volume_id | 3731b3c2-0b5f-4a54-beb9-82a7d7b74e8e |
+-----------+--------------------------------------+

$ cinder backup-show 98c50a79-4e04-40c8-8168-9ff6695c4b39

+-----------------------+--------------------------------------+
|        Property       |                Value                 |
+-----------------------+--------------------------------------+
|   availability_zone   |                 None                 |
|       container       |            Cinder-Backup             |
|       created_at      |      2016-06-13T06:09:49.000000      |
|      description      |                 None                 |
|      fail_reason      |                 None                 |
| has_dependent_backups |                False                 |
|           id          | 98c50a79-4e04-40c8-8168-9ff6695c4b39 |
|     is_incremental    |                 True                 |
|          name         |           Backup with git            |
|      object_count     |                  0                   |
|          size         |                  40                  |
|         status        |               creating               |
|       volume_id       | 3731b3c2-0b5f-4a54-beb9-82a7d7b74e8e |
+-----------------------+--------------------------------------+
{% endhighlight %}

위와 같이 `--incremental` 옵션을 이용해 백업을 하면 이전 백업분과 비교해 변경된 데이터들만 백업을 수행하게 된다.
`backup-show` 커맨드를 통해 `is_incremental` 속성 값이 `True`인 것을 확인할 수 있다. 
마찬가지로 백업이 완료되면 `status` 속성이 `available`로 바뀐다.

## Swift(Object Storage) 확인

백업이 완료가 되면 아래와 같이 Swift 컨테이너에 볼륨 백업본이 저장되어 있는 것을 볼 수 있다.

![Volume Backup to Swift](/post_images/openstack_cinder_backup_to_swift.png)

## 복원 (Restore)

백업이 되었다면 당연히 특정 백업 시점으로 `복원`이 되어야한다. 백업본을 이용한 볼륨을 `복원`하는 방법은 아래와 같다.

{% highlight bash %}
$ cinder help backup-restore
usage: cinder backup-restore [--volume <volume>] <backup>

Restores a backup.

Positional arguments:
  <backup>           ID of backup to restore.

Optional arguments:
  --volume <volume>  Name or ID of volume to which to restore. Default=None.
{% endhighlight %}

파라미터로 `복구할 백업본 ID`와 `볼륨명 또는 볼륨 ID`가 들어간다.
먼저 복원을 수행하려면 해당 볼륨의 상태가 `available` 상태이어야한다. 이를 위해 인스턴스와 볼륨을 잠깐 분리하였다. 
이제 이 명령어를 이용해 아래와 같이 `git` 설치 이전으로 `복원`을 해보도록 하겠다. 

{% highlight bash %}
$ cinder backup-restore --volume 3731b3c2-0b5f-4a54-beb9-82a7d7b74e8e 23c651a3-7958-4cf9-8587-c21feebcbdb6
+-------------+--------------------------------------+
|   Property  |                Value                 |
+-------------+--------------------------------------+
|  backup_id  | 23c651a3-7958-4cf9-8587-c21feebcbdb6 |
|  volume_id  | 3731b3c2-0b5f-4a54-beb9-82a7d7b74e8e |
| volume_name |                                      |
+-------------+--------------------------------------+
{% endhighlight %}

위의 명령어를 통해 `복원`을 수행한 후 `show` 커맨드를 이용해 볼륨의 상태를 체크해보면 `status`값이 `restoring-backup`로 변경된 것을 확인할 수 있다.

`Horizon`의 볼륨메뉴를 통해서 확인하면 아래와 같이 백업 복구 상태로 변경되었음을 확인할 수 있다 

![Volume Restoring](/post_images/openstack_cinder_volume_restore.png)

`복원`이 성공적으로 수행되면 `status`값이 `Available`로 변경된다.
