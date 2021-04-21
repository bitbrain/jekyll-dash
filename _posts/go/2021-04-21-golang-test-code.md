---
layout: post
title:  "[Golang] golang에서의 테스트 코드"
date:   2021-04-21
categories: golang
tags: golang
---

* content
{:toc}
  
# 테스트 파일 형식
Golang에서의 테스트 코드는 파일명에 `_test Suffix`를 붙인다. 다시 말해 `xxx_test.go`의 형식을 취한다고 생각 하면 된다.
  
# 테스트 작성하기
Golang에서 테스트 함수는 TestXxxx() {} 형식을 가지며 작성 방법은 아래의 2가지가 있다.
- `if문`과 `testing.T`를 이용하는 기본 형식
{% highlight go %}
package main

import "testing"

func TestIsEqual(t *testing.T) {
	a := true
	b := false
	if a != true {
		t.Error("a is", a)
	}
	if b != false {
		t.Error("b is", b)
	}
}
{% endhighlight %}

- `github.com/stretchr/testify/assert` 패키지를 이용하는 방식
{% highlight go %}
package main

import (
    "github.com/stretchr/testify/assert"
    "testing"
)

func TestIsEqualWithAssert(t *testing.T) {
    a := true
    b := false
    assert.Equal(t, a, true)
    assert.Equal(t, b, false)
}
{% endhighlight %}

# References
- [Package testing](https://golang.org/pkg/testing/)
- [Testify](https://github.com/stretchr/testify)
