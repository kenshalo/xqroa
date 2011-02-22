(:
    resources-config.xqy is the file where resources should be defined.  
    Resources are defined in a variable named resource-config:resource-definitions
    
    See examples below.
:)
module namespace resource-config = 'urn:us:gov:ic:jman:storefront:resource-config:v0.01';

(:
    Resource configuration document.
:)
declare variable $resource-config:resource-definitions 
    as element(resources) := <resources>
    <resource name="sigint-home">
        <path>/:ver/storefront/home</path>
        <representations>
            <representation extension="html" default="true"/>
            <representation extension="json" />
        </representations>
    </resource>
    <resource name="sigint-home">
        <path>/:ver/storefront</path>
    </resource>
    <resource name="category">
        <path>/:ver/storefront/category</path>
        <default-controller>true</default-controller>
        <display-name>Category Resource</display-name>
        <description><![CDATA[
            The category resource is an entry point into browseable report 
            categories.
        ]]>
        </description>
    </resource>
    <resource name="productbrowser">
        <path>/:ver/storefront/products/(:type)?/(:name)?</path>
        <representations>
            <representation extension="html" default="true"/>
            <representation extension="json" />
            <representation extension="xml" />
        </representations>
    </resource>
    <resource name="regions">
        <path>/:ver/storefront/regions/(:name)?/(:displaycountries)?</path>
        <representations>
            <representation extension="html" default="true"/>
            <representation extension="json" />
            <representation extension="xml" />
        </representations>
    </resource>
    <resource name="countries">
        <path>/:ver/storefront/countries</path>
        <display-name>Countries Resource</display-name>
        <description><![CDATA[
            The countries provides lists of countries that contain reports
        ]]>
        </description>
        <representations>
            <representation extension="html" default="true"/>
            <representation extension="json" />
            <representation extension="xml" />
        </representations>
    </resource>
    <resource name="date">
        <path>/:ver/storefront/date/(:year)?/(:month)?/(:day)?</path>
                <display-name>Date Resource</display-name>
        <description><![CDATA[
            The dates resource provides lists of report date information
        ]]>
        </description>
        <representations>
            <representation extension="html" />
            <representation extension="json" />
            <representation extension="xml" default="true"/>
        </representations>
        
    </resource>
    <resource name="country-topic">
        <path>/:ver/storefront/country/:cname/:tname</path>
        <display-name>Country Topic Resource</display-name>
        <description><![CDATA[
            The Country Topic Resource provides a list of reports for a country
            and topic
        ]]>
        </description>
        <representations>
            <representation extension="html" default="true"/>
            <representation extension="rss" />
            <representation extension="atom" />
            <representation extension="xml" />
        </representations>
    </resource>
    <resource name="page-directory">
        <path>/:ver/:user/storefront/pages</path>
    </resource>
    <resource name="sigint-home">
        <path>/:ver/storefront/sigint-home</path>
        <representations>
            <representation extension="html" default="true"/>
            <representation extension="json" />
        </representations>
    </resource>
    <resource name="search">
        <path>/:ver/storefront/search</path>
        <representations>
            <representation extension="json" />
            <representation extension="xml" />
        </representations>
    </resource>
    <resource name="reader">
        <path>/:ver/storefront/reader/</path>
    </resource>
    <resource name="report">
        <path>/:ver/storefront/report/(:serialnumber)?</path>
        <representations>
            <representation extension="html" />
            <representation extension="xml"/>
        </representations>
    </resource>
    <resource name="currentinformation">
        <path>/view/current-information</path>
    </resource>
    <resource name="report-production">
        <path>/view/report-production/(:type)?</path>
    </resource>
    <resource name="report-production-admin">
        <path>/:ver/view/admin/report-production/(:type)?/(:topic)?</path>
        <representations>
            <representation extension="xml" default="true"/>
        </representations>
    </resource>
    <resource name="user">
        <path>/user/(:user)?</path>
        <representation extension="html" />
        <representation extension="json" />
        <representation extension="xml" default="true"/>
    </resource>
    <resource name="subscription">
        <path>/:ver/storefront/:user/subscription</path>
        <representation extension="html" />
    </resource>    
</resources>;
