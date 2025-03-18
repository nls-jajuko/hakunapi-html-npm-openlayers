import proj4 from 'proj4';

import projDefs from './proj/projdefs.json';


const sridLookup = {},
  sridByUriLookup = {}, uriBySridLookup = {};

function registerProjDefs() {
  for (const [key, value] of Object.entries(projDefs)) {
      const  srid = value.srid,
        code = value.code,
        proj4def = value.proj4def,
        uri = value.uri;

      proj4.defs(code, proj4def);
      sridLookup[srid] = value;
      sridByUriLookup[uri] = srid;
      uriBySridLookup[srid] = uri;
  }

}
function getURIBySrid(srid) {
  return uriBySridLookup[srid];
}
function getSridByURI(uri) {
  return sridByUriLookup[uri];
}

function getSridInfoBySrid(srid) {
  return sridLookup[srid];
}

export { getURIBySrid, getSridByURI, projDefs, getSridInfoBySrid, registerProjDefs };
