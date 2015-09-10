{% macro render(post,is_index,post_extra_class) %}
<article class="article">
    <header class="article-title">
        {% if is_index== true %}
            <h2><a href="{{ url_for(post.path) }}">{{post.title}}</a></h2>
        {% else %}
            <h2>{{post.title}}</h2>
        {% endif %}
            <h5 class="date">{{ date(post.date,'YYYY/MM/DD')}}</h5>
            <div class="line"></div>
    </header>
    {% if is_index== true %}
        <div class="article-entry">{{ post.excerpt }}</div>
        <div class="article-more">
            <div class="line"></div>
            <a class="link" href="{{ url_for(post.path) }}">more>></a>
        </div>
    {% else %}
        <div class="article-entry">{{ post.content }}</div>
    {% endif %}
</article>

{% endmacro %}