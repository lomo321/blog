{% extends '_layout.swig' %}
{% import '_macro/article.swig' as article_template %}
{% block content %}
<!--{% for post in page.posts %}-->
    {{article_template.render(page)}}
    <div>fuck</div>
<!--{% endfor %}-->
{% endblock %}