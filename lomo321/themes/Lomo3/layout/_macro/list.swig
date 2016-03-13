{% macro render(post,is_archive) %}
    <a href="{{ url_for(post.path) }}" class="list-title">
        <h5 class="date">{{ date(post.date,'MM/DD')}}</h5>
        <h1 class="title">{{post.title}}</h1>
    </a>
{% endmacro%}