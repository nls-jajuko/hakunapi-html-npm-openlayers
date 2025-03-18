Alternate HTML app for hakunapi generated HTML pages.

# templates 

hakunapi properties
```
formats.html.dir=.../templates
```

# NPM built resources

The templates assume NPM built app to be available from base URL

```
.../static/hakunapi-html/hakunapi-html-map.css
.../static/hakunapi-html/hakunapi-html-map.es.js
```
These can be served with tomcat static servlet for dev purposes

```
<Context docBase="${catalina.base}/static" path="static" />
```

Static resources directory

.../static/hakunapi-html/

Cache configuration for static resources

...tomcat/static/WEB-INF/web.xml

```
<?xml version="1.0" encoding="ISO-8859-1"?>
<web-app>
<filter>
 <filter-name>ExpiresFilter</filter-name>
 <filter-class>org.apache.catalina.filters.ExpiresFilter</filter-class>
 <init-param>
    <param-name>ExpiresByType image</param-name>
    <param-value>access plus 10 minutes</param-value>
 </init-param>
 <init-param>
    <param-name>ExpiresByType text/css</param-name>
    <param-value>access plus 10 minutes</param-value>
 </init-param>
 <init-param>
    <param-name>ExpiresByType text/javascript</param-name>
    <param-value>access plus 10 minutes</param-value>
 </init-param>
</filter>
<servlet>
    <servlet-name>Assets</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
    <init-param>
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>Assets</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
<filter-mapping>
  <filter-name>ExpiresFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
</web-app>

```
