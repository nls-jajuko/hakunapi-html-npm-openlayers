<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
<#list links as link>
  <link rel="${link.rel}" type="${link.type}" title="${link.title}" href="${link.href}"/>
</#list>
  <link crossorigin href="../../static/hakunapi-html/hakunapi-html-map.css" rel="stylesheet">
  <title>${(featureType.title)!(featureType.name)} - Items</title>
  <style> .featureById { cursor: pointer;}</style>
</head>
<body>
<main>
  <div class="container-lg py-4">
    <nav class="nav justify-content-between" aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a class="d-flex align-items-center text-dark text-decoration-none" href="../../">Home</a></li>
        <li class="breadcrumb-item"><a class="d-flex align-items-center text-dark text-decoration-none" href="../../collections">Collections</a></li>
        <li class="breadcrumb-item"><a class="d-flex align-items-center text-dark text-decoration-none" href="../../collections/${featureType.name}">${(featureType.title)!(featureType.name)}</a></li>
        <li class="breadcrumb-item active" aria-current="page">Items</li>
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
      <h1>${featureType.title!featureType.name}</h1>
      <#if featureType.description??><p>${featureType.description}</p></#if>
      <label for="crs">Switch CRS:</label>
      <select name="crs" id="crs">
        <#list featureType.geom.srid as availableSRID>
        <#if availableSRID == 84>
            <#if srid == 84>
            <option value="http://www.opengis.net/def/crs/OGC/1.3/CRS84" selected>CRS84</option>
            <#else>
            <option value="http://www.opengis.net/def/crs/OGC/1.3/CRS84">CRS84</option>
            </#if>
        <#else>
            <#if availableSRID == srid>
            <option value="http://www.opengis.net/def/crs/EPSG/0/${availableSRID?c}" selected>EPSG:${availableSRID?c}</option>
            <#else>
            <option value="http://www.opengis.net/def/crs/EPSG/0/${availableSRID?c}">EPSG:${availableSRID?c}</option>
            </#if>
        </#if>
        </#list>
      </select>
      <button id="bbox" class="btn btn-primary">Set BBOX from View</button>	
    </header>
    
    <div id="map" class="map border pb-3 mb-3" style="height: 360px;">
    </div>
    
    <h2>Features</h2>
    <#if features?has_content>
    <div class="table-responsive">
      <table class="table table-striped table-sm">
        <#assign firstFeature = features[0]>
        <thead>
          <tr>
            <th>id</th>
            <#list firstFeature.properties?keys as key>
            <th>${key}</th>
            </#list>
          </tr>
        </thead>
        <tbody class="features">
          <#list features as feature>
          <tr>
            <td><a href="javascript:void(0)" class="featureById" data-feature-id="${feature.id}" class="text-decoration-none">${feature.id}</a></td>
            <#list feature.properties?values as value>
              <#if value??>
              <#if value?is_enumerable>
              <td><table><#list value as vv><tr><td>${vv}</td></tr></#list></table></td>
              <#else>
              <td>${value!""}</td>
              </#if>
              <#else>
              <td/>
              </#if> 
            </#list>
          </tr>
          </#list>
        </tbody>
      </table>
    </div>
    <#else>
    <p>No features found!</p>
    </#if>
    
    <nav aria-label="Pagination">
     <#if links??>
      <ul class="pagination">
        <#list links as link>
        <#if link.rel == "prev" && link.type == "text/html">
        <li class="page-item"><a class="page-link text-dark text-decoration-none" href="${link.href}">${link.title!"Previous page"}</a></li>
        </#if>
        </#list>
        <#list links as link>
        <#if link.rel == "next" && link.type == "text/html">
        <li class="page-item"><a class="page-link text-dark text-decoration-none" href="${link.href}">${link.title!"Next page"}</a></li>
        </#if>
        </#list>
      </ul>
      </#if>
    </nav>

    <footer class="pt-3 mt-4 text-muted border-top">Powered by hakunapi</footer>
  </div>
</main>
<script>document.getElementById("json-link").href = window.location.search === "" ? "?f=json" : window.location.search + "&f=json"</script>

<script type="module">
 import { Mapplet } from "../../static/hakunapi-html/hakunapi-html-map.es.js";

var data = [
<#list features as feature>
<#if feature.geometry??>
{
  "type": "Feature",
  "id": "${feature.id}",
  "geometry": ${feature.geometry}
},
</#if>
</#list>
];
    const srid = ${srid?c},
      uri = Mapplet.crs(srid);

    function links() {

      // links to features with a selection of params (crs)
      let el = document.getElementsByClassName('features')[0];
      if(el) {el.addEventListener('click',(e)=>{
	 if(e.target.dataset.featureId) {
	    let url = 'items/'+e.target.dataset.featureId+'?crs='+uri;
	    document.location.href=url;
	 }
      });
      }

      // link to other crs with params and updated crs ?
      document.getElementById('crs').addEventListener('change',(e)=>{
	  let selectedCrsURI = e.target.options[e.target.selectedIndex].value,
	      selectedSrid = Mapplet.srid(selectedCrsURI);
	  const params = (new URL(document.location)).searchParams;
	  params.set('crs',selectedCrsURI);
	  document.location.search = params.toString(); 	 
	
      });

       document.getElementById('bbox').addEventListener('click',(e)=>{
	 let extent = Mapplet.bbox(),
	     bboxCrs = Mapplet.bboxCrs(),
	     bbox = extent.join(',');
	 console.log( extent,bboxCrs,bbox );
	 const params = (new URL(document.location)).searchParams;
	 params.set('bbox',bbox);
	 params.set('bbox-crs',bboxCrs);
   params.delete('next');
	 document.location.search = params.toString();
      });
    }
   
    

    Mapplet.map().then((m)=>{ window.M = m;
      Mapplet.data(data);

      const params = (new URL(document.location)).searchParams;
      let bboxParam = params.get('bbox'),	
	bboxCrs = params.get('bbox-crs'),
	bbox = bboxParam ? bboxParam.split(',') : null,
	bboxSrid = bboxCrs ? Mapplet.srid(bboxCrs): 84;
      Mapplet.fit(bbox,bboxSrid);

      links();
    });


  console.log(srid,uri);

  
</script>
</body>
</html>
