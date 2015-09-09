{% extends '_layout.swig' %}
{% block content %}
    <div>archives {{page.current}}</br>
        {{page.total}}</br>
        {{page.per_page}}</br>
        {{page.next_link}}</br>
        {{page.next}}</br></div>

{% endblock %}