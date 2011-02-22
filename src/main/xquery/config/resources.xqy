(:
    Resource definitions used to be in this file but were moved to resource-config.xqy.

    resources.xqy contains methods that use the resource-config:resource-definitions 
    variable to construct additional information used by action-controller
    to process HTTP requests.
:)
module namespace res = 'urn:us:gov:ic:jman:storefront:resources:v0.01';
import module namespace global = 'urn:us:gov:ic:jman:storefront:global:v0.01' 
    at '/xquery/config/global.xqy';
import module namespace resource-config = 'urn:us:gov:ic:jman:storefront:resource-config:v0.01'
    at '/xquery/config/resource-config.xqy';

declare variable $res:ex as xs:string := "[a-zA-Z0-9_\-\+]+";
declare variable $res:url-req-regex as xs:string := fn:concat("(/", $res:ex, ")");
declare variable $res:url-opt-regex as xs:string := fn:concat("(/", $res:ex, ")?");
declare variable $res:path-req-regex as xs:string := fn:concat("(/:", $res:ex, ")");
declare variable $res:path-opt-regex as xs:string := fn:concat("(/\(:", $res:ex ,"\)\?)");

(:
    Initializes resources for the provided resource configuration and returns
    an element(resources) node that contains additional reqular expression 
    information used by action-controller.xqy to match urls and parameters to
    resource definitions.  If global:local-dev = fn:true() then the resource
    configuration document is generated everytime othewise the resource
    configuration is read from a document located at uri $global:resource-config
:)
declare function res:init() as element(resources) {
    if ($global:cache-resources = fn:true()) then
        let $resource-config-doc := fn:doc($global:resource-definition-uri)/resources
        return if($resource-config-doc) then
            $resource-config-doc
        else
            let $resources := res:generate-resource-definitions()
            let $d := xdmp:document-insert($global:resource-definition-uri, 
                $resources)
            return $resources
    else
        res:generate-resource-definitions() 
};

(:
    Generates resource definitions defined by resource-config:resource-definitions
:)
declare function res:generate-resource-definitions() {
    <resources>{
        for $res in $resource-config:resource-definitions/resource
        let $reps := $res/representations
        let $exts := fn:string-join($reps/representation/@extension, '|')
        return <resource name="{$res/@name}" root="{$res/@root}">
            {$res/*}
            <url-regex>{res:get-url-regex($res/path, $exts)}</url-regex>
            <path-regex>{res:get-path-regex($res/path, $exts)}</path-regex>
        </resource>
    }</resources>
};

(:
    Builds a regular expression to match url based on the path definition.
:)
declare function res:get-url-regex($path as xs:string, $exts as xs:string){
    let $r-path := res:path-replace($path, $res:url-req-regex, $res:url-opt-regex)
    let $regex := fn:concat('^', $r-path, '(\.(', $exts, '))?$')
    return $regex
};

(:
    Builda a regualr expression to parse path parameters based on the path definition.
:)
declare function res:get-path-regex($path as xs:string, $exts as xs:string) {
    let $p-path := res:path-replace($path, $res:path-req-regex, $res:path-opt-regex)
    let $regex := fn:concat('^', $p-path, '(\.(', $exts, '))?$')
    return $regex
};

(:
    Utility used by get-url-regex and get get-path-regex to build regular expressions.
:)
declare function res:path-replace($path as xs:string, $req-regex, $opt-regex) {
    let $tokens := fn:tokenize($path, "/")
    let $regex := for $token in $tokens
    let $seg := if (fn:matches($token, '\(:\w+\)')) then
        $opt-regex
    else if (fn:matches($token, ":\w+")) then
        $req-regex
    else if (fn:string-length($token)) then 
        fn:concat("(/", $token, ")")
    else
        ""        
    return $seg

    return fn:string-join($regex, '')
};