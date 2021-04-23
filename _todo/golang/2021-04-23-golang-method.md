---
layout: post
title:  "[Golang] Method란"
date:   2021-04-22
categories: golang
tags: golang
---

# 메서드 (Method)
Go 언어에는 클래스의 개념이 없다. 하지만 Type에 메서드를 정의할 수 있는데 메서드는 특수한 수신자(Receiver) 인자를 받는 함수이다. 이때 리시비(Receiver)는 `func 키워드와 함수명 사이`에 정의한다.

{% highlight go %}
type Triangle struct{ width, height float64 }

func (triangle Triangle) Area() float64 {
return triangle.width * triangle.height / 2
}

func TestTriangle(t *testing.T) {
triangle := Triangle{2, 3}
assert.Equal(t, float64(3), triangle.Area())
}
{% endhighlight %}

# References
- [Methods](https://tour.golang.org/methods/1)
