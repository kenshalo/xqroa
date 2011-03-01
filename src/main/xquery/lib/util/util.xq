module namespace util = 'xqroa:util:v1.0';

declare function util:trim($arg as xs:string) {
    fn:replace(fn:replace($arg,'\s+$',''),'^\s+','')
};

declare function util:trim-trailing-slash($arg as xs:string) {
    fn:replace($arg, '/$', '')
};

declare function util:trim-slashes($arg as xs:string) {
    fn:replace(fn:replace($arg,'/$',''),'^/','')
};

declare function util:replace-slash-with-dash($arg as xs:string) {
    fn:replace($arg, '/', '-')
};

declare function util:replace-sn-dash-with-slash($arg as xs:string) {
    fn:replace($arg, '(\w+)(\-)(\w+)(\-)(\w+)', '$1/$3/$5')
};

declare function util:build-response($code, $errors, $fn, $data) 
    as element (response) {
    <response>
        <status>
            <code>{$code}</code>
            <message></message>
            <errors>{$errors}</errors>
        </status>
        <function-name>{$fn}</function-name>
        <data>{$data}</data>
    </response>
};
