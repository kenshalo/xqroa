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
module namespace global = "urn:xqroa:global:v1.0";

(:
    Application variables
:)
declare variable $global:local-dev as xs:boolean := fn:true();
declare variable $global:public-dir as xs:string := "^/public";

(:
    Mime-types that action-controller will return in the HTTP response.
    
    For example, a resource with representation json and url {url}.json will set 
    a content-type header application/json.
:)
declare variable $global:mime-types as element(mime-types) := <mime-types>
    <mime-type extension="html" default="true">text/html</mime-type>
    <mime-type extension="json">application/json</mime-type>
</mime-types>;

(: Resource configuration variables :)
(:
    Variable used to cache resource configuration information.  If this variable 
    is false() evaluation of the $resource-config:resources document will 
    occur for each HTTP request.
    
    This variable should be set to false() for development, however if this 
    variable is true generated resource configuration information will be cached 
    in a document defined by the $resource-config:doc variable.
:)
declare variable $global:cache-resources := fn:false();

(:
    The uri to cache generated resource configuration.  This variable is not 
    used unless $resource-config:cache-resources := fn:true()
:)
declare variable $global:resource-definition-uri := '/app/resources.xml';

(: Action Controller configuration variables :)
declare variable $global:url-request-field as xs:string := 'url';
declare variable $global:controller-dir as xs:string := '/xquery/app/controller/';
declare variable $global:view-dir as xs:string := '/xquery/app/views/';