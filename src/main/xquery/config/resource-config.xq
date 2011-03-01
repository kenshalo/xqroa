(:
    resources-config.xqy is the file where resources should be defined.  
    Resources are defined in a variable named resource-config:resource-definitions
    
    See examples below.
    
    <resource name="category">
        <path>/:ver/storefront/category</path>
        <default-controller>true</default-controller>
        <display-name>Category Resource</display-name>
        <description><![CDATA[
            The category resource is an entry point into browseable report 
            categories.
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
