{% extends '_layout.swig' %}
{% import '_macro/article.swig' as article_template%}
{% block content %}
    {% for post in page.posts %}
        {{article_template.render(post,true)}}
    {% endfor %}
    <!--<div>-->
        <!--&lt;!&ndash;{{page.current}}</br>&ndash;&gt;-->
        <!--&lt;!&ndash;{{page.total}}</br>&ndash;&gt;-->
        <!--&lt;!&ndash;{{page.per_page}}</br>&ndash;&gt;-->
        <!--&lt;!&ndash;{{page.next_link}}</br>&ndash;&gt;-->
        <!--&lt;!&ndash;{{page.next}}</br>&ndash;&gt;-->
    <!--</div>-->
{% endblock %}
