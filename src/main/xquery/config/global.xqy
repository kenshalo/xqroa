module namespace global = 'urn:us:gov:ic:jman:storefront:global:v0.01';

import module namespace search = "http://marklogic.com/appservices/search" 
    at "/MarkLogic/appservices/search/search.xqy";

declare namespace msp = "urn:us:gov:ic:msp:v3.1";

(:
    Application variables
:)
declare variable $global:appdata-uri as xs:string := '/application';
declare variable $global:search-opts := 
<search:options>
    <search:search-option>unfiltered</search:search-option>
    <search:page-length>10</search:page-length>
    <search:term>
        <search:empty apply="all-results" />
        <search:term-option>punctuation-insensitive</search:term-option>
    </search:term>
    <search:constraint name="country-code">
        <search:range collation="http://marklogic.com/collation/"
            type="xs:string" facet="true">
            <search:facet-option>frequency-order</search:facet-option>
            <search:facet-option>descending</search:facet-option>
            <search:facet-option>limit=10</search:facet-option>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="CountryCode" />
        </search:range>
    </search:constraint>
    <search:constraint name="topic">
        <search:range collation="http://marklogic.com/collation/"
            type="xs:string" facet="true">
            <search:facet-option>frequency-order</search:facet-option>
            <search:facet-option>descending</search:facet-option>
            <search:facet-option>limit=10</search:facet-option>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="NIPFTopic" />
        </search:range>
    </search:constraint>
    <search:constraint name="actor">
        <search:range collation="http://marklogic.com/collation/"
            type="xs:string" facet="true">
            <search:facet-option>frequency-order</search:facet-option>
            <search:facet-option>descending</search:facet-option>
            <search:facet-option>limit=10</search:facet-option>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="NonStateActorCode" />
        </search:range>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="serial-number">
        <search:word>
            <search:element ns="urn:us:gov:cryp:das:pub" name="Serial" />
            <search:term-option>punctuation-insensitive</search:term-option>
        </search:word>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="tag-subject">
        <search:word>
            <search:element ns="urn:us:gov:cryp:das:pub" name="SubjectTopic" />
            <search:term-option>punctuation-insensitive</search:term-option>
        </search:word>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="tag-principal">
        <search:word>
            <search:element ns="urn:us:gov:cryp:das:pub" name="Principal" />
            <search:term-option>punctuation-insensitive</search:term-option>
        </search:word>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="requirement">
        <search:word>
            <search:element ns="urn:us:gov:cryp:das:pub" name="StandingReq" />
            <search:term-option>punctuation-insensitive</search:term-option>
        </search:word>
        <search:annotation>
        </search:annotation>
    </search:constraint>  
    <search:constraint name="user-meta">
        <search:custom facet="false">
            <search:parse apply="custom-parse-user-meta" ns="urn:us:gov:ic:jman:storefront:propstate:v0.01" at="/lib/application/property-state.xq"/>
        </search:custom>
    </search:constraint>
    <search:constraint name="user-props">
        <search:properties/>
    </search:constraint>
    <search:operator name="sort">
        <search:state name="relevance">
            <search:sort-order>
                <search:score />
            </search:sort-order>
        </search:state>
    </search:operator>
    <search:transform-results apply="snippet" 
        ns="urn:us:gov:ic:jman:storefront:helper:v1"
        at="/xquery/app/helper/result-transform-helper.xqy">
        <search:preferred-elements>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="Para" />
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="EmphasizedText" />
            <search:element ns="http://marklogic.com/entity" name="person" />
            <search:element ns="http://marklogic.com/entity" name="organization" />
        </search:preferred-elements>
        <search:max-matches>1</search:max-matches>
        <search:max-snippet-chars>150</search:max-snippet-chars>
        <search:per-match-tokens>20</search:per-match-tokens>
    </search:transform-results>
    <search:return-query>1</search:return-query>
    <search:operator name="user">
        <search:state name="unread">
            <search:transform-results apply="stateful-snippet" 
                ns="urn:us:gov:ic:jman:storefront:helper:v1"
                at="/xquery/app/helper/result-transform-helper.xqy">
                <search:param>unread</search:param>
            </search:transform-results>
            <search:page-length>100</search:page-length>
        </search:state>
        <search:state name="read">
            <search:transform-results apply="stateful-snippet" 
                ns="urn:us:gov:ic:jman:storefront:helper:v1"
                at="/xquery/app/helper/result-transform-helper.xqy">
                <search:param>read</search:param> 
            </search:transform-results>
            <search:page-length>200</search:page-length>
        </search:state>  
    </search:operator>
    <search:operator name="results">
        <search:state name="compact">
            <search:transform-results apply="snippet">
                <search:preferred-elements>
                    <search:element ns="urn:us:gov:ic:msp:v3.1" name="Para" />
                    <search:element ns="urn:us:gov:ic:msp:v3.1" name="EmphasizedText" />
                    <search:element ns="http://marklogic.com/entity"
                        name="person" />
                    <search:element ns="http://marklogic.com/entity"
                        name="organization" />
                </search:preferred-elements>
                <search:max-matches>1</search:max-matches>
                <search:max-snippet-chars>150</search:max-snippet-chars>
                <search:per-match-tokens>20</search:per-match-tokens>
            </search:transform-results>
        </search:state>
        <search:state name="detailed">
            <search:transform-results apply="snippet">
                <search:preferred-elements>
                    <search:element ns="urn:us:gov:ic:msp:v3.1" name="Para" />
                    <search:element ns="urn:us:gov:ic:msp:v3.1" name="EmphasizedText" />
                    <search:element ns="http://marklogic.com/entity"
                        name="person" />
                    <search:element ns="http://marklogic.com/entity"
                        name="organization" />
                </search:preferred-elements>
                <search:max-matches>2</search:max-matches>
                <search:max-snippet-chars>400</search:max-snippet-chars>
                <search:per-match-tokens>30</search:per-match-tokens>
            </search:transform-results>
        </search:state>
    </search:operator>
</search:options>;

(:
    Framework configuration variables
:)
declare variable $global:server as xs:string := "localhost:9000";
declare variable $global:version as xs:string := "v1";
declare variable $global:local-dev as xs:boolean := fn:true();

(:
    Mime-types that action-controller uses based on representations defined in
    resource-config.xqy resource definitions.  
    
    Extension in url us used to to set response content-type header.  
    
    For example, a resource with representation json and url {url}.json will set 
    a content-type header application/json.
    
    RW: After examining some headers I found that the content-type is blank.
    RW: I am modifying the XML slightly to fit the xpath used to query for
    RW: the mime time from within action-controller
:)
declare variable $global:mime-types as element(mime-types) := <mime-types>
    <mime-type extension="html" default="true">text/html</mime-type>
    <mime-type extension="json">application/json</mime-type>
</mime-types>;

(: RESOURCE CONFIGURATION VARIABLES :)
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

(: ACTION CONTROLLER CONFIGURATION VARIABLES :)
declare variable $global:url-request-field as xs:string := 'url';
declare variable $global:controller-dir as xs:string := '/xquery/app/controller/';
declare variable $global:view-dir as xs:string := '/xquery/app/view/';

(: Bind variable expected to be passed on all xcc calls := "nobody"   :)
declare variable $global:jumNS as xs:string external ;

(: Setter function which allows the $global:jumNS bind variable to be set from within xquery.
   Prefer its use for testing as the bind variable should be set by xcc.  It may also be used for admin type functions.
:)
declare function global:set-jumns($newval as xs:string){
let $empty := xdmp:set ($global:jumNS,$newval)
return
()
};

(: 
  Get the user from any source possible.
  Currently: first check the http request user name, then check the xcc variable 
:)
declare function global:get-user-prefer-request() as xs:string {
     
     let $reqUser := try { xdmp:get-request-username() } catch ($e) {""} 
     let $xccUser := if (fn:string-length($reqUser) = 0 )
                   then
                       try { xdmp:value("$global:jumNS") } catch ($e) {""}
                   else $reqUser
     let $user := if (fn:string-length($xccUser) = 0 )
                  then
                      "nobody"
                  else 
                      $xccUser
     return $user
} ;

(: 
  Get the user from any source possible.
  Currently: first check the xcc variable then check the http request user name
:)
declare function global:get-user-prefer-xcc() as xs:string {
     let $xccUser := try { xdmp:value("$global:jumNS") } catch ($e) {""}
     let $reqUser := if ( fn:string-length($xccUser) = 0 )
                   then
                        try { xdmp:get-request-username() } catch ($e) {""}
                   else $xccUser
     let $user := if (fn:string-length($reqUser) = 0 )
                  then
                      "nobody"
                  else 
                      $reqUser
     return $user
} ;