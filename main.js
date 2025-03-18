import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-icons/font/bootstrap-icons.css';
import 'ol/ol.css';
import 'swagger-ui-dist/swagger-ui.css';

import Map from 'ol/Map';
import View from 'ol/View';
import Hash from './hash';
import proj4 from 'proj4';
import { applyTransform } from 'ol/extent.js';
import { register } from 'ol/proj/proj4';
import { get as projGet } from 'ol/proj'
import { getTransform } from 'ol/proj.js';
import TileLayer from 'ol/layer/Tile.js';
import VectorLayer from 'ol/layer/Vector.js';
import VectorSource from 'ol/source/Vector.js';

import { webLang, normalizedLang, texts } from './locale';

import WMTS, { optionsFromCapabilities } from 'ol/source/WMTS';
import WMTSCapabilities from 'ol/format/WMTSCapabilities';
import GeoJSON from 'ol/format/GeoJSON';
import { fromExtent } from 'ol/geom/Polygon';
import { Feature } from 'ol';

import { getSridByURI, getURIBySrid, getSridInfoBySrid, registerProjDefs } from './projdefs';

// swagger for api.html
import { SwaggerUIBundle } from 'swagger-ui-dist';

registerProjDefs();
register(proj4);

const params = (new URL(document.location)).searchParams,
  lang = normalizedLang[params.get('lang')] || 'fin',
  crs = params.get('crs') || 'http://www.opengis.net/def/crs/OGC/1.3/CRS84';

document.lang = webLang[lang];
const locale = texts[lang];

const layerId = 'taustakartta';
const apiKey = '7cd2ddae-9f2e-481c-99d0-404e7bc7a0b2';
const wmtsUrl = `https://avoin-karttakuva.maanmittauslaitos.fi/avoin/wmts/1.0.0/WMTSCapabilities.xml?api-key=${apiKey}`;

const funcs = {
  "feature": (f) => {
    console.log("FEATURE", f)
  }

};


let proj =
  // crs parameter based or default
  projGet('CRS:84'),
  // crs parameter based or default
  sridInfo = null,
  // some crs are visualised with WebMercator
  viewSridInfo = getSridInfoBySrid(84);


let fromLonLat = getTransform('EPSG:4326', proj);
let center = [24, 61];

const hash = new Hash(undefined, undefined),
  map = new Map({
    target: 'map',
    view: new View({
      center: fromLonLat(center),
      projection: proj
    }),
    layers: [
    ]
  });
hash.addTo(map);
map.on('click', function (evt) {
  const feature = map.forEachFeatureAtPixel(evt.pixel, function (feature) {
    return feature;
  });
  funcs["feature"](feature);
});


const wmtsParser = new WMTSCapabilities();

let vectorSource = null,
  vectorSourceFormat = null;

async function mapplet(psrid) {
  // psrid is based on crs argument
  // defaults to http://www.opengis.net/def/crs/OGC/1.3/CRS84 

  // if psrid is numberlike, use it otherwise map URL to srid
  let srid = psrid == null || Number(psrid) == NaN ? getSridByURI(psrid || crs) : psrid;

  // assign based on crs
  sridInfo = getSridInfoBySrid(srid);

  // assign view srid based on configuration 
  let viewSrid = sridInfo.viewSrid;
  viewSridInfo = getSridInfoBySrid(viewSrid);

  // use tilematrixset from configuration
  let tileMatrixSet = viewSridInfo.tileMatrixSet,
    bbox = sridInfo.bbox;

  // assign proj for visualisation
  proj = projGet(viewSridInfo.code);

  // assign proj for data
  let dataProj = projGet(sridInfo.code);

  // assign proj and view for srid bbox operations
  fromLonLat = getTransform('EPSG:4326', proj);

  if (bbox[0] > bbox[2]) {
    bbox[2] += 360;
  }
  const extent = applyTransform(bbox, fromLonLat, undefined, 8);
  proj.setExtent(extent);
  const newView = new View({
    projection: proj,
  });
  map.setView(newView);
  newView.fit(extent);

  // visualise srid bounds
  const extentGeom = fromExtent(extent),
    extentFeat = new Feature(extentGeom);

  const extentSource = new VectorSource({

  });
  extentSource.addFeature(extentFeat);

  const extentLayer = new VectorLayer({
    source: extentSource,
    style: {
      'stroke-color': '#a00000'
    }
  });

  // create source for data
  vectorSource = new VectorSource({
  });
  vectorSourceFormat = srid == viewSrid ? new GeoJSON() : new GeoJSON({ dataProjection: dataProj, featureProjection: proj });

  const vectorLayer = new VectorLayer({
    source: vectorSource,
    style: {
      'fill-color': 'rgba(0,0,192,0.1)',
      'stroke-color': '#0000A0',
      'text-value': [
        'concat',
        'ID# ',
        ['id'],
      ],
      'text-font': '10px sans-serif',
      'text-fill-color': 'black',
      'text-stroke-color': 'white',
      'text-stroke-width': 1,
    }
  });

  // create WMTS background map and add layers
  await fetch(wmtsUrl)
    .then(function (response) {
      return response.text();
    })
    .then(function (text) {
      const result = wmtsParser.read(text);
      const wmtsLayers = result.Contents.Layer;

      const layers = [];
      wmtsLayers.filter(l => l.Identifier == layerId).forEach(l => {
        const options = optionsFromCapabilities(result, {
          layer: l.Identifier,
          matrixSet: tileMatrixSet,
          requestEncoding: 'REST'
        });
        console.log(options);
        const apiKeyOpts = {
          tileLoadFunction: (imageTile, src) => {
            imageTile.getImage().src = `${src}?api-key=${apiKey}`;
          }
        };

        let layer = new TileLayer({
          opacity: 1,
          source: new WMTS({ ...options, ...apiKeyOpts }),
          visible: false
        })

        layers.push(layer);
      });
      return layers[0];
    })
    .then(l => {
      map.addLayer(l);
      l.setVisible(true)
      map.addLayer(extentLayer);
      extentLayer.setVisible(true);
      map.addLayer(vectorLayer);
      vectorLayer.setVisible(true);
    });



  return map;

}

// minimalized api for HTML template pages
var api = {

  openapi: (domId, url) => {
    let swaggerOpts = {
      dom_id: domId,
      url: url,
      deepLinking: true,
      presets: [SwaggerUIBundle.presets.apis],
      plugins: [],
      layout: "BaseLayout"
    };
    console.log(swaggerOpts);
    return SwaggerUIBundle(swaggerOpts);
  },

  // initialize map
  map: mapplet,

  // srid and url mapping
  crs: (srid) => getURIBySrid(srid),
  srid: (uri) => getSridByURI(uri),

  // geojson to be shown on map
  data: (geojson) => {
    if (!geojson) {
      return;
    }
    if (Array.isArray(geojson)) {
      let feats = vectorSourceFormat.readFeatures({ "type": "FeatureCollection", "features": geojson });
      vectorSource.addFeatures(feats);
    } else {
      let feats = vectorSourceFormat.readFeatures(geojson);
      vectorSource.addFeatures(feats);
    }
  },

  // on features callbacks
  on: (subset, func) => {
    funcs[subset] = func;
  },

  // bbox output 
  bbox: (pbboxSrid) => {
    let bboxSrid = pbboxSrid || sridInfo.srid;
    let bboxSridInfo = getSridInfoBySrid(bboxSrid);

    let bboxProj = projGet(bboxSridInfo.code);

    let bboxToCrs = getTransform(proj, bboxProj);
    let extent = map.getView().calculateExtent(map.getSize());
    return applyTransform(extent, bboxToCrs, undefined, 8);
  },
  // bbox-crs output
  bboxCrs: (pbboxSrid) => {
    let bboxSrid = pbboxSrid || sridInfo.srid;
    let bboxSridInfo = getSridInfoBySrid(bboxSrid);
    return bboxSridInfo.uri;
  },

  // fit bbox or data if bbox not available
  fit: (bboxOrString, bboxSrid) => {
    const bbox = bboxOrString ? Array.isArray(bboxOrString) ? bboxOrString.map(s => Number(s)) : bboxOrString.split(',').map(s => Number(s)) : null;
    if (bbox && bboxSrid && bboxSrid != viewSridInfo.srid) {
      const bboxSridInfo = getSridInfoBySrid(bboxSrid),
        bboxProj = projGet(bboxSridInfo.code),
        bboxFrom = getTransform(bboxProj, proj);
      const extent = applyTransform(bbox, bboxFrom, undefined, 8);
      map.getView().fit(extent, { padding: [8, 8, 8, 8], minResolution: 2 });

    } else if (bbox && bboxSrid) {
      // assume crs equals to viewCrs
      map.getView().fit(bbox, map.getSize());
    } else if (bbox) {
      // assume crs equals to viewCrs
      map.getView().fit(bbox, map.getSize());
    } else if (vectorSource.getFeatures().length) {
      map.getView().fit(vectorSource.getExtent(), { padding: [8, 8, 8, 8], minResolution: 2 });
    }
  },
  clear: () => {
    vectorSource.clear();
  },

};

export { api as Mapplet };