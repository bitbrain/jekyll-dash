---
layout: post
title:  "함수형 프로그래밍 개념 정리"
date:   2021-04-22
categories: programming
tags: programming
---

* content
{:toc}

# Overview
사용하지 않으면 까먹는다고 이를 대비해 함수형 프로그래밍에서 사용되는 개념을 정리한다.   
예제는 Go로 작성했다.

# 일급 시민 (First class citizen)
함수가 값으로 변수에 담길 수 있고 다른 함수로 넘기거나 돌려받을 수 있는 것을 의미한다.
- 아래는 함수를 변수에 할당하는 예제이다.  
{% highlight go %}
func TestFirstClassCitizen(t *testing.T) {
    var idx int
    increase := func() int {
        idx++
        return idx
    }
    assert.Equal(t, 1, increase())
    assert.Equal(t, 2, increase())
}
{% endhighlight %}  

함수를 인자로 넘기거나 함수를 리턴받는 예제는 고계함수 부분을 참고하도록 하자.

# 고계(고차) 함수 (higher order function)
함수를 인자로 받거나 함수를 리턴하는 함수를 말한다.
- 인자로 함수를 받는 고계 함수
{% highlight go %}
func HighOrderFunctionWithFuncArgs(f func(num int)) {
    for i := 0; i < 5; i++ {
        f(i)
    }
}

func Example_highOrderFunctionWithFuncArgs() {
    HighOrderFunctionWithFuncArgs(func(num int) {
        fmt.Println(num)
    })
    // Output:
    // 0
    // 1
    // 2
    // 3
    // 4
}
{% endhighlight %}

- 함수를 리턴하는 고계 함수
{% highlight go %}
func HighOrderFunctionWithFuncReturn() func() int {
    var next int
    return func() int {
        next++
        return next
    }
}

func Example_highOrderFunctionWithFuncReturn() {
    gen := HighOrderFunctionWithFuncReturn()
    fmt.Println(gen())
    fmt.Println(gen())
    fmt.Println(gen())
    // Output
    // 1
    // 2
    // 3
}
{% endhighlight %}

# 클로저 (Closure)
함수 리터럴 외에서 선언한 변수를 함수 리터럴 내에서 마음대로 접근할 수 있는 개념을 의미한다.

{% highlight go %}
func HighOrderFunctionWithFuncArgs(f func(num int)) {
    for i := 0; i < 5; i++ {
        f(i)
    }
}

func Example_closure() {
	var numList []int
	HighOrderFunctionWithFuncArgs(func(num int) {
		numList = append(numList, num)
	})
	fmt.Println(numList)
	// Output:
	// [0 1 2 3 4]
}
{% endhighlight %}

# References
- [Discovery Go](http://www.yes24.com/Product/Goods/24759320?OzSrank=8)
