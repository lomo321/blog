{% extends '_layout.swig' %}
{% import '_macro/article.swig' as article_template %}
{% import '_macro/pagination.swig' as pagination_template %}
{% block content %}
    {% for post in page.posts %}
        {{article_template.render(post,true)}}
    {% endfor %}

    {{ pagination_template.render(page.total, page.current, page.prev_link, page.next_link)}}
{% endblock %}
