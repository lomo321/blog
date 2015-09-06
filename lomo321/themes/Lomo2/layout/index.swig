{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template%}
{% block content %}
    {% for post in page.posts %}
        {{post_template.render(post)}}
    {% endfor %}
{% endblock %}
