(:
    IMPORTANT: 
    This file should NOT have to be modified.  Modification will have impact 
    to all controllers and views in the application and should be coordinated 
    among the team.  

    ActionController is a main xquery module that serves as the main controller 
    for the application.  This module is returned by the applcation's URL
    rewriter. (see rewriter.xqy)  
    
    ActionController uses the following logic to process uris to controllers 
    (resources):
    1. split url by /
    2. determine request-content type to set from url
    3. parse url backwards to find controller name
    4. create map that contains scoping information where {:key} = {value-in-uri}
    5. if there is a value for path prefix determine if additional values should
       be added to path parameter map
    6. determine HTTP method and call corresponding method in controller with 
       map as parameter.
        
    TODO 
    Add support in resources.xqy and logic in eval-controller for subordinate
    controller directories.  For example evaluate a controller at uri
    fn:concat($controllers-dir, 'some-dir') where 'some-dir' is defined in 
    resources.xqy    
:)
xquery version "1.0-ml";
declare namespace msp = "urn:us:gov:ic:msp:v3.1";
import module namespace global = 'urn:us:gov:ic:jman:storefront:global:v0.01'
    at '/xquery/config/global.xqy';
import module namespace res = "urn:us:gov:ic:jman:storefront:resources:v0.01" 
    at "/xquery/config/resources.xqy";
import module namespace util = "urn:us:gov:ic:jman:storefront:util:v0.01" 
    at "/xquery/lib/util/util.xq";
import module namespace error = "urn:us:gov:ic:jman:storefront:error:v0.01" 
    at "/xquery/config/error.xqy";
import module namespace json = "urn:us:gov:ic:jman:storefront:json:v0.01" 
    at "/xquery/lib/util/json.xqy"; 

declare namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.01";
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";

(:
    Initialize resources
:)
declare variable $res:resources as element(resources) := res:init();

(:
    Process request is the main entry point to process requests.  It gets url
    information and delegates to the correct controller file if there is a 
    controller defined for the resource.
:)
declare function controller:process-request() {
    (: Get request information :)
    let $url := xdmp:url-encode(util:trim-trailing-slash(
        xdmp:get-request-field($global:url-request-field)))
    let $http-method := xdmp:get-request-method()
    
    (: Get the resource information for the request :)
    let $resource := controller:get-resource-config($url)
    return if($resource[@name != 'not-found']) then
        let $params := controller:get-parameter-map($url, $resource)
        return controller:eval-controller($resource, $http-method, $params, $url)
    else 
        error:page(404, "Not Found", $res:resources)
}; 

(:
    Returns the resource configuration for the passed url.  If no resource is 
    found for the url this method returns <resource name="not-found"></resource>
    indicating no resource was found.
:)
declare function controller:get-resource-config($url as xs:string) 
    {
    (: determine which resource to use :)
    let $found-resource := for $resource in $res:resources/resource
    where fn:matches($url, $resource/url-regex/text())
    return $resource
    
    return if($found-resource) then
        $found-resource
    else if (fn:string-length($url) = 0) then
        $res:resources/resource[@root = "true"]
    else
        <resource name="not-found"></resource>
    
};

declare function controller:get-parameter-map($url as xs:string, 
    $resource as element(resource)) {
    let $url-regex := fn:concat($resource/url-regex/text())
    let $resource-path := $resource/path/text()
    let $resource-regex := $resource/path-regex/text()

    (: determine the number of tokens in the url -1 is for token created :)
    let $cnt := fn:count(fn:tokenize($resource-path, "/"))
    let $map-tokens := 
        for $idx in 1 to $cnt - 1
        return fn:concat("$", $idx, "=>\$", $idx)
    let $map-str := fn:string-join($map-tokens, ";")

    (: replace keys in map :)
    let $map-keys := fn:replace($resource-path, $resource-regex, $map-str)
    
    (: get the representation :)
    let $map-keys := fn:concat($map-keys, ';representation=>$', $cnt)
    
    (: replace values for corresponding keys :)
    let $map := fn:replace($url, $url-regex, $map-keys)
  
    (: create the map - removes whitespace before inserting values :)
    let $params := map:map()
    let $d := 
        for $str in fn:tokenize($map, ";")
        let $kv-pair := fn:tokenize($str, "=>")
        let $key := $kv-pair[1]
        let $val := $kv-pair[2]
        return if ($key != $val) then
            if (fn:string-length($val) and $val != '/') then
                map:put($params, fn:replace($key, '\W+', ''), fn:replace($val, '(/|\.)', ''))
            else
                map:put($params, fn:replace($key, '\W+', ''), "") 
        else ''
    
    (: pass through HTTP request parameters :)
    let $request-params := map:map()
    let $dummy := for $fn in xdmp:get-request-field-names()
    return map:put($request-params, $fn, xdmp:get-request-field($fn))
    
    (: add them with key 'request-params' :)
    let $dummy := map:put($params, 'request-params', $request-params)
    let $body := controller:get-request-body($params)

    return $params
};

(:
    pulls out the request body and returns a map containing the body.  If the
    content-type is 'application/x-www-form-urlencoded' then the request fields
    are pulled from the body, put into a map, and that map is put into the body 
    map which is returned to the calling function.
    
    TODO write a test case for this function Content-Type (capital T) doesn't
    work
:)
declare function controller:get-request-body($params as map:map){
    let $body-map := map:map()
    let $body-parms := map:get($params,'request-params')
    let $content-type := xdmp:get-request-header("Content-type")
    let $d := map:put($body-map, 'Content-type', $content-type)
    return if ($content-type eq "application/x-www-form-urlencoded") then
        let $field-names := xdmp:get-request-field-names()
        let $l := xdmp:log($field-names)
        for $f in $field-names
            let $v := xdmp:get-request-field($f)
            let $p := map:put($body-parms, $f, $v)
            return
                ''
    else
        let $body := xdmp:get-request-body()
        return if ($body ne ()) then
            map:put($params, "request-body", $body)
        else ''
};

declare function controller:eval-controller($resource as element(resource), 
    $method as xs:string, $params as map:map, $url as xs:string) {
    (: evaluate the controller :)
    let $controller-name := data($resource/@name)
    let $default-controller := $resource/default-controller/text()
    let $controller-file := fn:concat($global:controller-dir, 
        $controller-name, '-controller.xqy')
    let $import-declaration := fn:concat(
                'import module namespace controller =',
                '"urn:us:gov:ic:jman:storefront:controller:v0.1" at ',
                '"', $controller-file, '";'
            )
    
    let $ns := "controller"
    let $function-call := if ($method = "DELETE") then
        fn:concat($ns, ":destroy(", $params, ")")
    else if ($method = "GET") then
        fn:concat($ns, ":show(", $params, ")")
    else if ($method = "POST") then
        fn:concat($ns, ":create(", $params, ")")
    else if ($method = "PUT") then
        fn:concat($ns, ":update(", $params, ")")
    else 
        xdmp:set-response-code(405, fn:concat("Method: ", $method, " is not supported"))
        
    return try {
        let $model := if ($default-controller) then
            <p>used default controller... no model</p>
        else
            xdmp:eval(fn:concat($import-declaration, $function-call),
                (),
                <options xmlns="xdmp:eval">
                    <isolation>different-transaction</isolation>
                    <prevent-deadlocks>false</prevent-deadlocks>
                </options>
            )
        
        (: 
          set the response content type.  Uses the following logic:
          1) if representation in params then look up mime-type from res:mime-types
          2) if there is no representation in params (url didn't) contain an extension
          then use the default representation defined by the resource
          3) if all else fails use the default mime-type in $res:mime-types   
        :)
        let $rep := if(map:get($params, 'representation')) then
            map:get($params, 'representation')
        else if($resource/representations/representation[@default = 'true']) then
            fn:data($resource/representations/representation[@default = 'true']/@extension)
        else 
            fn:data($global:mime-types/mime-type[@default = 'true']/@extension)
        
        let $d := xdmp:set-response-content-type($global:mime-types/mime-type[@extension = $rep]/text())
        let $view-file := fn:concat($global:view-dir, $controller-name, ".", $rep, ".xsl")
        
        (: 
          JSON by-passes view module and uses library function in lib/json.xqy 
        :)
        return if ($rep = "json") then
            json:serialize($model)
        else if ($rep = "xml") then
            $model
        else
            xdmp:xslt-invoke(
                $view-file, 
                <response>{$model}</response>, 
                $params)
    } catch ($e) {
        let $log := xdmp:log($e)
        let $error-code := $e/error:code
        let $t := xdmp:set-response-content-type("text/xml")
        let $response := if ($error-code = "SVC-FILOPN") then
            xdmp:set-response-code(500, fn:concat("Internal Server Error. ", 
                "Could not process request method: ", $method, " uri: ", $url, 
                " Could not find controller file: ", $controller-file))
        else if ($error-code = "XDMP-UNDFUN") then
            xdmp:set-response-code(405, fn:concat("Method:", $method, " is not ",
                "supported by resource: ", $controller-name))
        else 
            xdmp:set-response-code(500, fn:concat("Internal Server Error. ", 
                "Could not process request method: ", $method, " uri: ", $url,
                " error code: ", $error-code))
        return ($response, $e)
    }
};

(: Main module so call process-request() ... :)
controller:process-request()