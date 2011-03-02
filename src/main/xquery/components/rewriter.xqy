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
    @see: resource-config.xq 
:)

(:
    The rewriter serves a the main entry point into the xqroa framework for HTTP
    requests.  The rewriter gets the request url, adds a 'url' request parameter, and
    replaces any '?' characters with '&' characters. 
      
    Additional request parameters are passed to the action-controller as they 
    were recieved.  The rewriter then returns a url to the action-controller.xqy,
    which delegates to the correct controller based on the url and resource 
    configuration defined in resource-config.xq.
     
    IMPORTANT
    This file should not be changed with out coordination as it will have an 
    effect on how all urls are rewritten for the entire application.
     
    Url rewriter for the application.  To configure the xqroa framework, set the 
    HTTP server's root directory attribute to the project root directory.  
    Then set the url rewriter attribute for the HTTP server to 
    xquery/components/rewriter.xqy.
        
    Examples of original url and re-written url:
    url: /home -> /components/action-controller.xqy?url=home
    url: /category/topic/Florida/beaches?filter=west-coast&attractions=tennis ->
         /components/action-controller.xqy?url=/category/topic/Florida/beaches
             &filter=west-coast&attractions=tennis
:)
xquery version "1.0-ml";

import module namespace global = "urn:xqroa:global:v1.0"
    at "/xquery/config/global.xq";

declare function local:construct-new($url as xs:string)
    as xs:string 
{
    fn:concat("url=",replace($url, "\?", "&amp;"))
};

declare variable $url as xs:string := xdmp:get-request-url();
if(fn:matches($url, $global:public-dir)) then
    fn:concat("/xquery", $url)
else
    fn:concat("/xquery/components/action-controller.xqy?", 
        local:construct-new($url))
