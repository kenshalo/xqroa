(:
    Copyright 2010 Daniel Kenshalo

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    
    @author: <a href="mailto:kenshalo@gmail.com">Dan Kenshalo</a>
    @since: August 1, 2010
    @version: 1.0
:)
module namespace error = "urn:xqroa:error:v1.0";

import module namespace g = "urn:xqroa:global:v1.0" 
    at "/xquery/config/global.xq";

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
        <p>{
            for $i in $data
            return <p>{$i}</p>
        }</p>
      </body>
    </html>
};