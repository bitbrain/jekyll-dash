---
layout: post
title:  "Java's Garbage Collection - Serial Garbage Collector"
date:   2016-04-23
categories: java
tags: java
---

* content
{:toc}

## 개요
자바 개발자라면 누구나 알고 있는 `GC (Garbage Collection)`에 대해 다루고자 한다<br/>
인간의 망각에 대비해 여러 `Garbage Collector` 중 이번 포스팅에서는 가장 기본이 되는 `Serial Garbage Collector`에 대해 기록한다.

기본적으로 `GC`의 대상이 되는 영역은 자바의 여러 매모리 영역 중 `Heap`영역과 `Method Area(Perm)`영역이다.

`Hotspot JVM`은 `Generational Collection`을 사용하는데 `Heap`영역을 `Young Generation`과 `Old Generation`으로 나눈다.
이름에서 이미 눈치챘겠지만 `Young Generation`에는 어린 객체들이 `Old Generation`에는 오래된 객체들이 할당되는 공간이다.

![Java Heap](/post_images/java_heap.png)

## 1. Young Generation
앞서 설명했지만 `Young Generation`영역에는 새로운 객체가 할당되거나 어린 객체들이 모여있는 공간이다. 이 `Young Generation`영역은 다시 `Eden`영역과 `Survivor`영역으로 나뉜다.

### - Eden
`Eden`영역은 새로운 객체가 할당되는 공간이다. 객체들이 할당되다가 `Eden`영역이 가득차게 되면 발생하는게 `Minor GC`이며 이 때 살아남은 객체들은 `Survivor`영역으로 이동이 되게 되고 `Eden`영역은 싹 비워진다.

### - Survivor
`Eden`영역에서 살아남은 객체들은 바로 이 `Survivor`영역으로 넘어오게 된다. `Survivor`영역은 물리적으로는 `Survivor 1`, `Survivor 2`영역으로 구분되며 논리적으로는 `From`, `To`로 구분되기도 한다.

이렇게 분리를 해놓은 것은 `Old Generation`으로 `Promotion`하기 위한 `Age`를 체크하기 위함이다.

`Survivor 1`영역과 `Survivor 2`영역은 둘중에 한 공간은 반드시 아무것도 할당되지 않은 영역이다.
`Minor GC`가 일어나게 되면 `Survivor`영역내에서 객체들의 이동이 일어나게 되는데 `Survivor 2`영역이 비어있으면 `Survivor 1`에서 `Survivor 2`로 이동되어지고 `Survivor 1`영역이 비어있으면 `Survivor 2`에서 `Survivor 1`로 이동이 된다.
이때 이동하기 전에 객체들이 할당되어 있던 영역이 `From`, 이동되는 영역을 `To`라고 한다. 이렇게 이동되면서 내부적으로 카운트가 세어지는데 이 카운트를 `Age`라고 한다. 쉽게 말해 `Young Generation`내 객체들의 나이를 세는 것이다.

이렇게 수 많은 `Minor GC`의 반복 끝에 `Survivor`영역 내의 객체들이 일정 `Age`에 도달하게 되면 `Old Generation`으로 이동이 되는데 이를 `Promotion`이라고 한다.

## 2. Old Generation
`Old Generation`영역은 `Young Generation`영역에서 `Promotion`된 늙은 객체들이 모여있는 공간이다. 수많은 `Minor GC`를 반복하고 이중 늙은 객체들을 `Old Generation`으로 `Promotion`하기를 반복하다가 `Old Generation`영역의 공간이 부족해지면 이때 일어나는것이 `Major GC`이다.

`Major GC` 수행중에 Old 객체의 `Young Generation` 객체 참조 케이스를 위해 `Card Table`과 `Write Barrier`이라는 장치가 있는데 이 부분은 이번 포스팅에서는 생략하도록 하겠다.


## 정리
`Garbage Collection`은 크게 `Client GC`와 `Server GC`로 나뉜다. 이번에 다룬 `Serial Garbage Collector`은 자바의 기본 `Client GC`이며 다음에 다룰 `G1 Garbage Collector`의 기본이기도 하다.

자바 개발자라면 기본적으로 JVM이 메모리를 어떻게 쓰는지 알아야한다. 앞으로 자바를 지탱하는 메모리 구조 외에도 클래스로더 등 다양한 주제를 포스팅할 예정이다.

이 부분에 대해 체계적으로 공부하고 싶은 사람은 `Java Performance Fundamental`이라는 책을 참고하면 된다. 익숙해질때까지 여러번 반복해서 읽어보길 권장한다.
