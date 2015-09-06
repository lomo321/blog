<!doctype html>
<html>
   {% include './_partials/head.swig' %}
<body>
<div id="container">
    {% include './_partials/sideBar.swig' %}
    <div id="main">
        {% include './_partials/mobile-nav.swig' %}
        <div id="content">{% block content%}{% endblock %}</div>
    </div>
</div>
    {% include './_partials/foot.swig' %}
</body>

</html>