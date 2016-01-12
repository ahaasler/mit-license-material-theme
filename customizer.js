function changeColor(color) {
    var css = 'themes/material-' + color + '.css';
    css = css.replace('-default', '');

    var link = document.createElement('link');
    link.setAttribute('rel', 'stylesheet');
    link.setAttribute('type', 'text/css');
    link.setAttribute('href', css);

    document.getElementsByTagName('head').item(0).appendChild(link);
}

window.onload = function() {
    var colors = [];

    function addCustomizer() {
        var customizer = document.createElement('div');
        customizer.setAttribute('id', 'customizer');
        customizer.setAttribute('style', 'position:absolute;top:0;left:0;')
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
        customizer.appendChild(select);
        document.getElementsByTagName('body')[0].appendChild(customizer);
    }

    addCustomizer();
}
