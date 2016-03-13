{% macro render(total, currentPage, prev, next) %}
{% if total > 1 %}

<div id="pagination">
    <ul>
        <li><a href="/"><i class="icon-angle-double-left"></i></a></li>
        {% if prev %}
        <li><a href="/{{prev}}"><i class="icon-angle-left"></i></a></li>
        {% elseif currentPage == 2 %}
        <li><a href="/"><i class="icon-angle-left"></i></a></li>
        {% else %}
        <li><a class="disabled"><i class="icon-angle-left"></i></a></li>
        {% endif %}

        {% if currentPage > 2%}
        <li><a class="disabled"><i class="icon-dot-3"></i></a></li>
        {% endif %}


        {% if currentPage - 1 > 0%}
        {% if currentPage - 1 != 1%}
        <li><a href="/page/{{currentPage-1}}">{{ currentPage - 1}}</a></li>
        {% else %}
        <li><a href="/">1</a></li>
        {% endif %}
        {% endif %}

        <li><a class="current">{{ currentPage }}</a></li>


        {% if currentPage + 1 <= total%}
        <li><a href="/page/{{currentPage+1}}">{{ currentPage + 1}}</a></li>
        {% endif %}
        {% if total - currentPage > 1 %}
        <li><a class="disabled"><i class="icon-dot-3"></i></a></li>
        {% endif %}

        {% if next %}
        <li><a href="/{{next}}"><i class="icon-angle-right"></i></a></li>
        {% else %}
        <li><a class="disabled" disabled><i class="icon-angle-right"></i></a></li>
        {% endif %}
        <li><a href="/page/{{total}}"><i class="icon-angle-double-right"></i></a></li>
    </ul>
</div>
{% endif %}

{% endmacro %}