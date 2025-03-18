const texts = {
    fin: {
     
    },
    swe: {
     
  
    },
    eng: {
     
    }
  
  };

  function applyLocale(locale){
    for (const [key, value] of Object.entries(locale.el)) {
        const localisedEl = document.getElementById(key);
        if (!localisedEl) {
          continue;
        }
        localisedEl.innerText = value;
      }
      
  }

  function getLocalizationGroup(locale,group) {
    return locale[group];
  }

const  webLang = {
    fi: 'fi',
    fin: 'fi',
    'fi-FI': 'fi',
    sv: 'sv',
    swe: 'sv',
    'sv-FI': 'sv',
    en: 'en',
    eng: 'en'
  },

  normalizedLang = {
    fi: 'fin',
    fin: 'fin',
    'fi-FI': 'fin',
    sv: 'swe',
    swe: 'swe',
    'sv-FI': 'swe',
    en: 'eng',
    eng: 'eng'
  };

  export { texts, applyLocale, webLang, normalizedLang, getLocalizationGroup } ;