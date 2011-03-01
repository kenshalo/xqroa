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
module namespace util = 'urn:xqroa:util:v1.0';

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
