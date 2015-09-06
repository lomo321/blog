{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template %}
{% block content %}
<section id="posts" class="posts-expand">
    test test
</section>
{% endblock %}
{% block test%}
<div>
    {% for post in page.posts %}
    {{ post_template.render(post) }}
    {% endfor %}
</div>
{% endblock %}
