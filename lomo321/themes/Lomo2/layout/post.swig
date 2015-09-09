{% extends '_layout.swig' %}
{% import '_macro/article.swig' as article_template %}
{% block content %}
    <div>fuck</div>

    {{ article_template.render(page) }}
    <div>fuck</div>

{% endblock %}
