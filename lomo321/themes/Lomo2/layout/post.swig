{% extends '_layout.swig' %}
{% import '_macro/article.swig' as article_template %}
{% block content %}


    {{ article_template.render(page) }}


{% endblock %}
