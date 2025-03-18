<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
<#list links as link>
  <link rel="${link.rel}" type="${link.type}" title="${link.title}" href="${link.href}"/>
</#list>
  <link crossorigin href="../../../static/hakunapi-html/hakunapi-html-map.css" rel="stylesheet">
  <title>${featureType.name} - ${id}</title>
  <style>
  </style>
</head>
<body>
<main>
  <div class="container py-4">
    <nav class="nav justify-content-between" aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a class="d-flex align-items-center text-dark text-decoration-none" href="../../../">Home</a></li>
        <li class="breadcrumb-item"><a class="d-flex align-items-center text-dark text-decoration-none" href="../../../collections">Collections</a></li>
        <li class="breadcrumb-item"><a class="d-flex align-items-center text-dark text-decoration-none" href="../../../collections/${featureType.name}">${(featureType.title)!(featureType.name)}</a></li>
        <li class="breadcrumb-item"><a class="d-flex align-items-center text-dark text-decoration-none" href="../../../collections/${featureType.name}/items?crs=http%3A%2F%2Fwww.opengis.net%2Fdef%2Fcrs%2FEPSG%2F0%2F3067">Items</a></li>
        <li class="breadcrumb-item active" aria-current="page">${id}</li>
      </ol>
      <ul class="nav">
        <li class="nav-item">
          <a class="navbar-brand" id="json-link" target="_blank">JSON</a>
        </li>
        <li class="nav-item">
          <a href="https://github.com/nlsfi/hakunapi" target="_blank">
            <svg width="32" height="32" viewBox="0 0 98 96" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M48.854 0C21.839 0 0 22 0 49.217c0 21.756 13.993 40.172 33.405 46.69 2.427.49 3.316-1.059 3.316-2.362 0-1.141-.08-5.052-.08-9.127-13.59 2.934-16.42-5.867-16.42-5.867-2.184-5.704-5.42-7.17-5.42-7.17-4.448-3.015.324-3.015.324-3.015 4.934.326 7.523 5.052 7.523 5.052 4.367 7.496 11.404 5.378 14.235 4.074.404-3.178 1.699-5.378 3.074-6.6-10.839-1.141-22.243-5.378-22.243-24.283 0-5.378 1.94-9.778 5.014-13.2-.485-1.222-2.184-6.275.486-13.038 0 0 4.125-1.304 13.426 5.052a46.97 46.97 0 0 1 12.214-1.63c4.125 0 8.33.571 12.213 1.63 9.302-6.356 13.427-5.052 13.427-5.052 2.67 6.763.97 11.816.485 13.038 3.155 3.422 5.015 7.822 5.015 13.2 0 18.905-11.404 23.06-22.324 24.283 1.78 1.548 3.316 4.481 3.316 9.126 0 6.6-.08 11.897-.08 13.526 0 1.304.89 2.853 3.316 2.364 19.412-6.52 33.405-24.935 33.405-46.691C97.707 22 75.788 0 48.854 0z" fill="#24292f"/></svg>
          </a>
        </li>
      </ul>
    </nav>

    <header class="pb-2 mb-2">
      <h1>${featureType.title!featureType.name} / ${id}</h1>
      <#if featureType.description??><p>${featureType.description}</p></#if>
    </header>
    
    <div id="map" class="border pb-3 mb-3" style="height: 360px;"></div>
    
    <h2>Properties</h2>
    <table class="table">
      <tbody>
        <tr>
          <td>id</td>
          <td>${id}</td>
        </tr>
        <#list properties as key, value>
        <tr>
          <td>${key}</td>
          <#if value??>
            <#if value?is_enumerable>
              <td><table><#list value as vv><tr><td>${vv}</td></tr></#list></table></td>
            <#else>
              <td>${value!""}</td>
            </#if>
          <#else>
            <td/>
          </#if>
        </tr>
        </#list>
      </tbody>
    </table>
       
    <footer class="pt-3 mt-4 text-muted border-top">Powered by hakunapi/footer>
  </div>
</main>
<script>document.getElementById("json-link").href = window.location.search === "" ? "?f=json" : window.location.search + "&f=json"</script>
<script type="module">
 import { Mapplet } from "../../../static/hakunapi-html/hakunapi-html-map.es.js";

var data = [
<#if geometry??>
{
  "type": "Feature",
  "id": "${id}",
  "geometry": ${geometry}
}
</#if>
];

    Mapplet.map().then(()=>{
      Mapplet.data(data);
      Mapplet.fit();
    });


</script>
</body>
</html>

