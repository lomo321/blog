{% extends '_layout.swig' %}
{% import '_macro/list.swig' as list_template%}
{% block content %}
<div class="archive">

    {% for post in page.posts %}
    {% set year %}
    {% set post.year = date(post.date, 'YYYY') %}

        {% if post.year !== year %}
            {% set year = post.year %}
    <h2 class="cal" ><i class="demo-icon icon-calendar"></i></h2>
    <a class="line2"></a>

    <h2 class="archive-year" >{{ year }}</h2>
        {% endif %}
        {{ list_template.render(post,page.archive)}}
    {% endfor %}
    <a class="line2"></a>
</div>
{% endblock %}