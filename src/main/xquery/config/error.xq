module namespace error = "urn:us:gov:ic:jman:storefront:error:v0.01";

import module namespace g = "urn:us:gov:ic:jman:storefront:global:v0.01" 
    at "/xquery/config/global.xqy";

declare function error:page($status-code, $msg, $data) {
    let $c := xdmp:set-response-content-type("application/xml")
    let $d := xdmp:set-response-code($status-code, $msg)
    return <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>{fn:concat($status-code, " ", $msg)}</title>
        <meta name="robots" content="noindex,nofollow"/>
      </head>
      <body>
        <h1>Error occurred</h1>
        <h2>Http Status Code: {$status-code}</h2>
        <p class="application">
            <a href="/v1/storefront/">Latest Storefront Home {$g:version}</a>
        </p>
        <p class="webservice">
            <a href="/v1/storefront">Latest Storefront Webserivce {$g:version}</a>
        </p>
        <p>{$data}</p>
      </body>
    </html>
};