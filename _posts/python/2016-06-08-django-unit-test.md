---
layout: post
title:  "Django's Unit Test"
date:   2016-06-08
categories: python
tags:
- python
- django
---

* content
{:toc}

## 개요
`django.test` 패키지는 파이썬의 `unittest` 모듈을 사용한다.


## 테스트 코드 작성
아래는 `unitest.TestCase`를 확장한 `django.test.TestCase`를 이용한 테스트 코드 예제이다.

{% highlight python %}
 from django.test import TestCase
 from myapp.models import Animal

 class AnimalTestCase(TestCase):
     def setUp(self):
         Animal.objects.create(name="lion", sound="roar")
         Animal.objects.create(name="cat", sound="meow")

     def test_animals_can_speak(self):
         """Animals that can speak are correctly identified"""
         lion = Animal.objects.get(name="lion")
         cat = Animal.objects.get(name="cat")
         self.assertEqual(lion.speak(), 'The lion says "roar"')
         self.assertEqual(cat.speak(), 'The cat says "meow"')
{% endhighlight %}

테스트 케이스들을 돌리게 되면 테스트 유틸리티는 기본적으로 모든 파일 내의 `unitest.TestCase`의 서브클래스이고 테스트 케이스가 test로 시작하는 모든 테스트 케이스들을 찾는다.
이후 자동적으로 검출된 테스트 케이스들에서 테스트 수트(Test suites)를 빌드하고 이 테스트 수트(Test suites)를 실행시킨다.

## 테스트 코드 실행
테스트 코드를 작성한 이후에는 프로젝트 내의 `manage.py` 유틸리티를 통해서 테스트를 실행실킬 수 있다.

{% highlight bash %}
$ ./manage.py test
{% endhighlight %}

기본적으로 위와 같이 실행하면 현제의 워킹 디렉토리 아래의 "test*.py"에 해당하는 모든 파일을 찾아 수행한다.
만약 특정 테스트 케이스만 수행하고자 한다면 아래와 같은 방법으로 수행하면 된다.

{% highlight bash %}
# Run all the tests in the animals.tests module
$ ./manage.py test animals.tests

# Run all the tests found within the 'animals' package
$ ./manage.py test animals

# Run just one test case
$ ./manage.py test animals.tests.AnimalTestCase

# Run just one test method
$ ./manage.py test animals.tests.AnimalTestCase.test_animals_can_speak

# Run all the tests under animals directory
$ ./manage.py test animals/
{% endhighlight %}