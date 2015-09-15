{% macro render(post,is_index,post_extra_class) %}
<article class="article">
    <header class="article-title" id="article-title-{{post.title}}">
        {% if is_index== true %}
        <h1><a href="{{ url_for(post.path) }}">{{post.title}}</a></h1>
        {% else %}
        <h1>{{post.title}}</h1>
        {% endif %}
        <h5 class="date">{{ date(post.date,'YYYY/MM/DD')}}</h5>

        <div class="line"></div>
    </header>
    {% if is_index== true %}
    <div class="article-entry">{{ post.excerpt }}</div>
    <div class="article-more">
        <div class="line"></div>
        <a class="link" href="{{ url_for(post.path) }}">More</a>
    </div>
    {% else %}
    <div class="article-entry">{{ post.content }}</div>
    <div class="article-more">
        <div class="line"></div>
        {% if post.prev %}
        <a class="prev-next" href="{{url_for(post.prev.path)}}">上一篇：{{post.prev.title}}</a>
        {% endif %}
        {% if post.next %}
        <a class="prev-next" href="{{url_for(post.next.path)}}">下一篇：{{post.next.title}}</a>
        {% endif %}
    </div>
    {% endif %}

    {%if is_index != true %}
    <div class="duoshuo">
        <!-- 多说评论框 start -->
        <div class="ds-thread" data-thread-key="article-title-{{post.title}}" data-title="{{post.title}}"
             data-url="http://lomo321.github.io{{ url_for(post.path) }}"></div>
        <!-- 多说评论框 end -->
        <!-- 多说公共JS代码 start (一个网页只需插入一次) -->
        <script type="text/javascript">
            var duoshuoQuery = {short_name: "{{ theme.duoshuo_info.duoshuo }}"};
            (function () {
                var ds = document.createElement('script');
                ds.type = 'text/javascript';
                ds.async = true;
                ds.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') + '//static.duoshuo.com/embed.js';
                ds.charset = 'UTF-8';
                (document.getElementsByTagName('head')[0]
                || document.getElementsByTagName('body')[0]).appendChild(ds);
            })();
        </script>
        <!-- 多说公共JS代码 end -->
    </div>
    {% endif %}

</article>

{% endmacro %}