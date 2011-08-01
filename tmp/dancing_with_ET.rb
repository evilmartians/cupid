require 'rubygems'
require 'ruby-debug'
require 'savon'
require 'cgi'

client = Savon::Client.new do
  wsdl.document = "https://webservice.s4.exacttarget.com/etframework.wsdl"
end

client.wsse.credentials "username", "password"
client.wsse.created_at = Time.now.utc
client.wsse.expires_at = (Time.now + 60).utc
client.http.headers["SOAPAction"] = '"urn:example#service"'

# p client.wsdl.soap_actions

# 1058396

# [:create, :perform, :update, :schedule, :configure, :version_info, :execute, :extract, :get_system_status, :query, :delete, :retrieve, :describe]
body = {
  'wsdl:Objects' => {
    'wsdl:EmailAddress' => 'wuuuuut@tester.com',
    'wsdl:Attributes' => [
        {"wsdl:Name" => "First Name", "wsdl:Value" => "Wuuuuut"},
        {"wsdl:Name" => "Last Name", "wsdl:Value" => "Teeeester"},
        {"wsdl:Name" => "Company", "wsdl:Value" => "Northern Trail Outfitters"}
      ],
    'wsdl:Lists' => {
      'wsdl:ID' => '251',
      'wsdl:Status' => 'Active'
    },
    :attributes! => {
      'wsdl:Lists' => {'xsi:type' => 'wsdl:SubscriberList'}
    }
  
  }
}

header = {
  'a:Action' => 'Retrieve',
  'a:MessageID' => 'urn:uuid:99e6822c-5436-4fec-a243-3126c14924f6',
  'a:ReplyTo' => {
      'a:Address' => 'http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous'
    },
  'VsDebuggerCausalityData' => 'uIDPo5GdUXRQCEBNrqnw0gOEloMAAAAAIAi4IHpPlUiMs1MZ2raBIhJnF/jqJLlAgZIny03R+tgACQAA',
  'a:To' => 'https://webservice.s4.exacttarget.com/Service.asmx'
  }
'
<a:MessageID>urn:uuid:99e6822c-5436-4fec-a243-3126c14924f6</a:MessageID>
<a:ReplyTo>
  <a:Address>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</a:Address>
</a:ReplyTo>
<VsDebuggerCausalityData xmlns="http://schemas.microsoft.com/vstudio/diagnostics/servicemodelsink">uIDPo5GdUXRQCEBNrqnw0gOEloMAAAAAIAi4IHpPlUiMs1MZ2raBIhJnF/jqJLlAgZIny03R+tgACQAA</VsDebuggerCausalityData>
<a:To s:mustUnderstand="1">https://webservice.s4.exacttarget.com/Service.asmx</a:To>
<o:Security s:mustUnderstand="1" xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
  <u:Timestamp u:Id="_0">
    <u:Created>2011-07-27T15:04:42.722Z</u:Created>
    <u:Expires>2011-07-27T15:09:42.722Z</u:Expires>
  </u:Timestamp>
  <o:UsernameToken u:Id="uuid-8e2ca2bf-1581-4d7a-a981-bbdab4639bc3-1">
    <o:Username>username</o:Username>
    <o:Password>password</o:Password>
  </o:UsernameToken>
</o:Security>'
# 
body = '<RetrieveRequest>
  <ObjectType>DataFolder</ObjectType>
  <Properties>ID</Properties>
  <Properties>Name</Properties>
  <Properties>ParentFolder.ID</Properties>
  <Properties>ParentFolder.Name</Properties>
  <Filter xsi:type="SimpleFilterPart">
    <Property>Account</Property>
    <SimpleOperator>equals</SimpleOperator>
    <Value>1058484</Value>
  </Filter>
</RetrieveRequest>'

body = '<RetrieveRequest>  
      <ObjectType>List</ObjectType>  
      <Properties>ListName</Properties>  
      <Properties>ID</Properties>  
      <Filter xsi:type="SimpleFilterPart">  
         <Property>ListName</Property>  
         <SimpleOperator>equals</SimpleOperator>  
         <Value>All Subscribers</Value>  
      </Filter>  
   </RetrieveRequest>'
   
body = '<RetrieveRequest>
<ClientIDs>
<ID>1058484</ID>
</ClientIDs>
<ObjectType>DataFolder</ObjectType>
<Properties>ID</Properties>
<Properties>Name</Properties>
<Properties>ParentFolder.ID</Properties>
<Properties>ParentFolder.Name</Properties>
<Filter xsi:type="SimpleFilterPart">
<Property>ContentType</Property>
<SimpleOperator>like</SimpleOperator>
<Value>email</Value>
</Filter>
</RetrieveRequest>'
                      
# body = '<RetrieveRequest>
# <ClientIDs>
# <ID>1058396</ID>
# </ClientIDs>
# <ObjectType>DataFolder</ObjectType>
# <Properties>ID</Properties>
# <Properties>Name</Properties>
# <Properties>ParentFolder.ID</Properties>
# <Properties>ParentFolder.Name</Properties>
# <Filter xsi:type="SimpleFilterPart">
# <Property>ContentType</Property>
# <SimpleOperator>like</SimpleOperator>
# <Value>email</Value>
# </Filter>
# </RetrieveRequest>'

html = CGI.escapeHTML('<center><h2>Way Cool Email</h2></center>')

# body = '
#     <Objects xsi:type="Email">  
#        <ObjectID xsi:nil="true"/>
#        <Client><ID>1058484</ID></Client>
#        <CategoryID>277</CategoryID>
#        <HTMLBody>'+html+'</HTMLBody>  
#        <Subject>Test Subject111</Subject>  
#        <EmailType>HTML</EmailType>  
#        <IsHTMLPaste>true</IsHTMLPaste>  
#     </Objects>'

namespaces = {
  'xmlns:s'=>"http://schemas.xmlsoap.org/soap/envelope/",
  'xmlns:a'=>"http://schemas.xmlsoap.org/ws/2004/08/addressing",
  'xmlns:u'=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
  'xmlns:xsi'=>"http://www.w3.org/2001/XMLSchema-instance",
  'xmlns:xsd'=>"http://www.w3.org/2001/XMLSchema",
  'xmlns:o'=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
}
# 
response = client.request :retrieve do |soap|
  soap.input = ['RetrieveRequestMsg', { 'xmlns'=>"http://exacttarget.com/wsdl/partnerAPI"}]
  soap.header = header
  soap.env_namespace = :s
  soap.namespaces = namespaces
  soap.body = body
end
# 
# response = client.request :create do |soap|
#   soap.input = ['CreateRequest', { 'xmlns'=>"http://exacttarget.com/wsdl/partnerAPI"}]
#   soap.header = header
#   soap.env_namespace = :s
#   soap.namespaces = namespaces
#   soap.body = body
# end