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

(:
    Add resources and url mappings for your application to this file.
    
    Resources are defined in a variable named 
    resource-config:resource-definitions
    
    See examples below.
    
    <resource name="category" root="true">
        <path>/:ver/my-site/category</path>
        <default-controller>true</default-controller>
        <display-name>Category Resource</display-name>
        <description><![CDATA[
            The category resource is an entry point into browseable content.
        ]]>
        </description>
        <representations>
            <representation extension="html" default="true"/>
            <representation extension="json" />
        </representations>
    </resource>
:)
module namespace resource-config = 
    "urn:xqroa:resource-config:v1.0";

(:
    Resource configuration document.
:)
declare variable $resource-config:resource-definitions 
    as element(resources) := <resources>
    (: add your resources here... :)
</resources>;
