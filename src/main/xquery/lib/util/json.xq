xquery version "1.0-ml";
(:
 : module: json.xqy - functions to convert XML nodes to JSON
 : @author: Mike Fagan
 : @since: May 26, 2009
 : @version: 1.0
:)

module namespace json = "urn:us:gov:ic:jman:storefront:json:v0.01";

(: function to convert a sequence of nodes to a JSON array of Objects :)

declare function json:serialize(
    $node as node()*
  ) as xs:string
{
  
  let $d := fn:trace("Serializing nodes to JSON", "call-json-transform")
  let $result := if ( fn:count($node) > 1 ) then
    let $results := for $item in $node return json:node-to-json( $item )
    return fn:concat('[',fn:string-join($results,','),']')
  else json:node-to-json($node)
  return fn:concat("{'", fn:local-name($node), "':", $result, "}")
};


(: function to convert a the attributes of a node to a JSON attribute object :)

declare function json:node-attrs-to-json(
     $node as node()
  ) as xs:string
{
    let $attribs := 
        for $attr in $node/@*
        return if (fn:matches(xs:string($attr), '[^0-9.]')) then
            fn:concat("'", fn:local-name($attr),"':'", $attr, "'")
        else 
            fn:concat("'", fn:local-name($attr),"':'", $attr, "'")

    return if (fn:count($attribs) = 0 ) then
        ''
    else 
        fn:concat("'attributes':{",fn:string-join($attribs,','),'},')
};


(: function to convert a XML node to a JSON Object :)

declare function json:node-to-json(
      $node as node()
) as xs:string
{
    let $attrs := json:node-attrs-to-json($node)
    let $childNames := fn:distinct-values(
        for $child in $node/* 
        return fn:local-name($child)
    )
    let $childJson :=
        for $name in $childNames
       (: loop over property names gathering up the values in an array if needed :)
        let $valStrings := 
            for $val in $node/*[fn:local-name() = $name]
                let $valText := $val/text()
                return if (fn:count($val/*) = 0) then
                    if (fn:matches($valText, '[^-]+[^0-9.]') or 
                        fn:string-length($valText) = 0) then
                        fn:concat("'", $valText, "'")
                    else $val
                        else json:node-to-json($val)
                    
        let $prop := if (fn:count($valStrings) > 1 ) then
            fn:concat('[', fn:string-join($valStrings,', '), ']')
        else $valStrings
            return fn:concat("'", $name, "':", $prop)

        return fn:concat('{', $attrs, fn:string-join($childJson,', '), '}' )
};