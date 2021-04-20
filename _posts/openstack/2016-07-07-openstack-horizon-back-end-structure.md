---
layout: post
title:  "[OpenStack] Horizon Horizon Project Back-end Structure"
date:   2016-07-07
categories: openstack
tags:
- openstack
---

* content
{:toc}

## Overview
이번 포스팅에서는 `Horizon` 개발을 위한 `백-엔드 아키텍처`를 정의하고자한다. Python 환경이 익숙하지 않다보니 아무래도 많이 버벅거린다. `프론트-엔드 아키텍처`는 다음 포스팅에서 다루도록 하겠다.
 <br/><br/>
`Horizon`은 Python의 구조로 볼때 Horizon의 큰 프로젝트 내에 `horizon`과 `openstack_dashboard` 두개의 어플리케이션으로 이루어져있다.<br/>
Python에서의 프로젝트와 어플리케이션의 개념은 다음의 [링크](http://jeremy.kr/2016-05-10/getting-started-1/)를 참고바란다<br/>

* `horizon` 어플리케이션에는 Horizon 대시보드에서 사용하는 각종 UI 컴포넌트들이 정의되어 있다.
* `openstack_dashboard` 어플리케이션에서는 horizon 어플리케이션 내의 컴포넌트를 이용해 OpenStack 대시보드를 구현하고 있다.

![OpenStack Horizon Project Diagram](/post_images/openstack_horizon_project_diagram.png)


## openstack_dashboard application

`openstack_dashboard` 어플리케이션은 아래와 같은 구조로 이루어져 있다.

![openstack_dashboard Application Structure](/post_images/openstack_dashboard_structure.png)


### 1. dashboards package

`dashboards package`는 위에서 설명했듯이 오픈스택 대시보드에서 필요한 메뉴, 화면, 비즈니스 로직을 구성하고 있는 핵심 패키지이다.

#### 1-1. 메뉴 구성

Horizon의 메뉴구성은 다음과 같은 컴포넌트로 이루어져 있다.<br/>

> Dashboard: 대 분류<br>
> PanelGroup: 중 분류 (PanelGroup은 dashboard 패키지 내에서 클래스를 정의하지 않고 `enabled 패키지`에서 사이드 메뉴 설정을 할 때 관계를 위한 클래스만 생성한다.)<br>
> Panel: 소 분류<br>

![Horizon Menu Structure](/post_images/openstack_horizon_menu_structure.png)

![Horizon Menu Structure](/post_images/openstack_dashboard_dashboards_package_structure.png)

#### 1-2. Dashboard

Horizon에서 대분류를 나타낼 때 사용한다.<br>
horizon 어플리케이션의 `Dashboard 클래스`를 상속한 클래스 파일을 정의함으로서 생성 가능하며 `enabled 패키지` 내의 dashboard 플러그인과 매핑된다.

ex) Horizon Identity 대시보드 예
{% highlight python %}
from django.utils.translation import ugettext_lazy as _
 
import horizon
 
 
class Identity(horizon.Dashboard):
    name = _("Identity")
    slug = "identity"
    default_panel = 'projects'
 
 
horizon.register(Identity) 
{% endhighlight %}

**horizon.Dashboard 의 주요 속성**<br>

* name: 화면에 노출되는 대시보드 명
* slug: 유니크한 ID 값, 이 값을 이용해 URL을 노출함

#### 1-3. Panel

Horizon에서 실질적인 소분류 메뉴를 나타낼 때 사용한다.<br/>
horizon 어플리케이션의 `Panel 클래스`를 상속한 클래스 파일을 정의함으로서 생성 가능하며 `enabled 패키지` 내의 panel 플러그인과 매핑된다.

ex) Horizon Identity Aggregates 패널 예
{% highlight python %}
import logging
 
from django.utils.translation import ugettext_lazy as _
 
import horizon
 
from openstack_dashboard.api import nova
 
LOG = logging.getLogger(__name__)
 
 
class Aggregates(horizon.Panel):
    name = _("Host Aggregates")
    slug = 'aggregates'
    permissions = ('openstack.services.compute',)
 
    def allowed(self, context):
        # extend basic permission-based check with a check to see whether
        # the Aggregates extension is even enabled in nova
        try:
            if not nova.extension_supported('Aggregates', context['request']):
                return False
        except Exception:
            LOG.error("Call to list supported extensions failed. This is "
                      "likely due to a problem communicating with the Nova "
                      "endpoint. Host Aggregates panel will not be displayed.")
            return False
        return super(Aggregates, self).allowed(context) 
{% endhighlight %}

**horizon.Panel 의 주요 속성**<br>

* name: 화면에 노출되는 패널 명
* slug: 유니크한 ID 값, 이 값을 이용해 URL을 노출함
* permission: 접근 권한 설정
* allowed (Overriden Method): 접근 권한을 확장할 때 사용 (위의 예제에서는 접근 권한 외에 Nova 서비스에서 Aggregates 확장 기능을 지원하는지 여부도 판단)
* can_register (Static Method): 패널이 등록되기 위한 조건을 걸 때 사용, 'permission'이나 'allowed' 처럼 접근 권한 및 정책 기반이 아닌 설정 기반의 조건에 따라 판단

#### 1-4. View의 기본 흐름

![Horizon Single Table Menu Flow](/post_images/openstack_dashboard_datatableview_flow.png)

![Horizon Tab Menu Flow](/post_images/openstack_dashboard_tabbedtableview_flow.png)


#### 1-5. views (views.py)

해당 패널에서 사용할 뷰를 정의하고 데이터를 로드하는 로직을 구현하는 클래스<br>

* 뷰 컴포넌트 로드
* 뷰 템플릿 로드
* 페이지 타이틀 정의
* 뷰에 바인딩할 데이터 로딩

#### 1-6. view components

`views.py`에서 사용할 뷰를 정의하는 클래스, `DataTable`나 `TabTable`를 상속받아 구현한다.<br>

* DataTable의 경우 테이블 뷰 컴포넌트 정의 (컬럼, 테이블 명, 테이블 출력 및 컨트롤 설정, 테이블 액션 등)
* 일반 메뉴의 구조: DataTableView(views.py) → DataTable(tables.py)
* TabTable의 경우 일부 'views.py' 역할과 겹침 (뷰 컴포넌트 로드, 뷰 템플릿 로드, 탭 타이틀 및 URL 정의, 뷰에 바인딩할 데이터 로딩)
* 탭 메뉴의 구조: TabbedTableView(views.py) → TabGroup(tabs.py) → TableTab(tabs.py) → DataTable(tabs.py)

#### 1-7. urls (urls.py)

Request URL과 View 클래스를 매핑한다.

#### 1-8. templates (folder)

뷰 컴포넌트에서 사용하는 html 템플릿들을 관리한다.

#### 1-9. tests (package)

해당 패널의 테스트 코드를 관리한다.


### 2. enabled package

위의 `dashboards 패키지` 내에서 정의한 `Dashboard`, `Panel` 들에 대한 관계, 순서 및 해당 대시보드에서 추가로 정의할 Angular 모듈, Java Script 모듈, 스타일 시트 등을 정의할 수 있다.

![openstack_dashboard enabled package flow](/post_images/openstack_dashboard_enabled_package_flow.png)

ex) Project 대시보드 예
{% highlight python %}
# The slug of the dashboard to be added to HORIZON['dashboards']. Required.
DASHBOARD = 'project'
# If set to True, this dashboard will be set as the default dashboard.
DEFAULT = True
# A dictionary of exception classes to be added to HORIZON['exceptions'].
ADD_EXCEPTIONS = {}
# A list of applications to be added to INSTALLED_APPS.
ADD_INSTALLED_APPS = ['openstack_dashboard.dashboards.project']
 
ADD_ANGULAR_MODULES = [
    'horizon.dashboard.project',
]
 
AUTO_DISCOVER_STATIC_FILES = True
 
ADD_JS_FILES = []
 
ADD_JS_SPEC_FILES = []
 
ADD_SCSS_FILES = [
    'dashboard/project/project.scss'
]
{% endhighlight %}

ex) Compute 패널 그룹 예
{% highlight python %}
from django.utils.translation import ugettext_lazy as _
 
# The slug of the panel group to be added to HORIZON_CONFIG. Required.
PANEL_GROUP = 'compute'
# The display name of the PANEL_GROUP. Required.
PANEL_GROUP_NAME = _('Compute')
# The slug of the dashboard the PANEL_GROUP associated with. Required.
PANEL_GROUP_DASHBOARD = 'project'
{% endhighlight %}

ex) Overview 패널 예
{% highlight python %}
# The slug of the panel to be added to HORIZON_CONFIG. Required.
PANEL = 'overview'
# The slug of the dashboard the PANEL associated with. Required.
PANEL_DASHBOARD = 'project'
# The slug of the panel group the PANEL is associated with.
PANEL_GROUP = 'compute'
 
# If set, it will update the default panel of the PANEL_DASHBOARD.
# DEFAULT_PANEL = 'default'
 
# Python panel class of the PANEL to be added.
ADD_PANEL = 'openstack_dashboard.dashboards.project.overview.panel.Overview'
{% endhighlight %}
