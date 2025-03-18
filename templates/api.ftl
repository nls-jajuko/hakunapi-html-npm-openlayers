<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Swagger UI</title>
<link href="${basePathTrailingSlash}static/hakunapi-html/hakunapi-html-map.css" rel="stylesheet">
<style>
html
{
box-sizing: border-box;
overflow: -moz-scrollbars-vertical;
overflow-y: scroll;
}
*,
*:before,
*:after
{
box-sizing: inherit;
}
body {
margin:0;
background: #fafafa;
}
img[alt="Swagger UI"] { display: none; }
.topbar { background-color: transparent !important; }
</style>
</head>
<body>
<div id="swagger-ui"></div>
<script type="module">
 import { Mapplet } from "${basePathTrailingSlash}static/hakunapi-html/hakunapi-html-map.es.js";

window.onload = function() {
window.ui = Mapplet.openapi('#swagger-ui', "${basePathTrailingSlash}api.json")
}
</script>
</body>
</html>
