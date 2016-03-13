<footer id="footer">
    <div class="footer-content">
        {% if theme.friends  %}
        <div class="friend-link">
                友情链接:
            {% for key ,val in theme.friends %}
                <a target="_blank" href="{{val}}">{{ key }}</a>
            {% endfor %}
        </div>
        {% endif %}
        <div class="visit-me">
            visit me:
            <a target="_blank" href="http://weibo.com/lomo123"><i class="icon-weibo"></i></a>
            <a target="_blank" href="https://github.com/lomo321"><i class="icon-github-squared"></i></a>
            <a target="_blank" href="https://instagram.com/leungmohh/"><i class="icon-linkedin-squared"></i></a>
        </div>
        <div class="lomo">
            <span class="a">----</span><span class="b">----</span><span class="c">------</span>
            Lomo 2015 @ Hexo
            <span class="c">------</span><span class="b">----</span><span class="a">----</span>
        </div>
    </div>
</footer>