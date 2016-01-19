function changeColor(color) {
    var css = 'themes/material-' + color + '.css';
    css = css.replace('-default', '');

    var link = document.createElement('link');
    link.setAttribute('rel', 'stylesheet');
    link.setAttribute('type', 'text/css');
    link.setAttribute('href', css);

    document.getElementsByTagName('head').item(0).appendChild(link);
    if (document.getElementsByTagName('link').length > 4) {
        link = document.getElementsByTagName('link').item(0);
        link.parentNode.removeChild(link);
    }
}

function toggleGravatar() {
    var gravatar = document.getElementById('gravatar');
    if (gravatar === null) {
        gravatar = document.createElement('img');
        gravatar.setAttribute('id', 'gravatar');
        gravatar.setAttribute('src', 'http://www.gravatar.com/avatar/9094ec062b91c713390b7e9099a11fa0');
        var article = document.getElementsByTagName('article').item(0);
        article.insertBefore(gravatar, article.childNodes[0]);
    } else {
        gravatar.parentNode.removeChild(gravatar);
    }
}

window.onload = function() {
    var colors = [];

    function addColorSelector(parent) {
        var select = document.createElement('select');
        select.setAttribute('name', 'color');
        select.setAttribute('onchange', 'changeColor(this.value);')
        for (var i = 0; i < colors.length; i++) {
            var option = document.createElement('option');
            option.setAttribute('value', colors[i]);
            option.appendChild(document.createTextNode(colors[i]));
            if (colors[i] === 'default') {
                option.selected = true;
            }
            select.appendChild(option);
        }
        parent.appendChild(select);
    }

    function addGravatarToggle(parent) {
        var button = document.createElement('button');
        button.setAttribute('onclick', 'toggleGravatar();')
        button.appendChild(document.createTextNode('Toggle gravatar'));
        parent.appendChild(button);
    }

    function addCustomizer() {
        var customizer = document.createElement('div');
        customizer.setAttribute('id', 'customizer');
        customizer.setAttribute('style', 'position:absolute;top:0;left:0;')
        addColorSelector(customizer);
        addGravatarToggle(customizer);
        document.getElementsByTagName('body')[0].appendChild(customizer);
    }

    addCustomizer();
}
