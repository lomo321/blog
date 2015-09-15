{% extends '_layout.swig' %}
{% import '_macro/list.swig' as list_template%}
{% block content %}
<div class="archive">
    {% for post in page.posts %}
    {% set year %}
    {% set post.year = date(post.date, 'YYYY') %}

        {% if post.year !== year %}
            {% set year = post.year %}
            <h2 class="archive-year" >{{ year }}</h2>
        {% endif %}


        {{ list_template.render(post,page.archive)}}
    {% endfor %}
<div>
{% endblock %}