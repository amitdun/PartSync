public class PartSyncController {
    @AuraEnabled
    public static string syncParts(){
        String result ='';
        Try{
            Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:CQ_Creds');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        system.debug(response.getStatusCode());
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
        List<Object> objList = (List<Object>) JSON.deserializeUntyped(response.getBody());
        Map<String,Id> actMap = new Map<String,Id>();
        for (Account act : [select id,Name from account where name in ('High Volume','Low Volume')]) {
            actMap.put(act.Name,act.id);
        }
        Set<String> allParts = new Set<String>();
        for (SQX_Part__c p : [select id,Part_Number__c from SQX_Part__c]) {
            allParts.add(p.Part_Number__c);
        }

        Map<String, Object> caseMap = new Map<String, Object>();
        List<SQX_Part__c> partList = new List<SQX_Part__c>();
        for(Object obj: objList){
            Map<String, Object> properties = (Map<String, Object>)obj;
            if(!allParts.Contains((String)properties.get('Part Number'))){
                SQX_Part__c part = new SQX_Part__c();
                part.Name = (String)properties.get('Part Description');
                part.Part_Number__c = (String)properties.get('Part Number');
                Integer totalqtshipped = (Integer) properties.get('Total Quantity Shipped');
                part.Active__c = true;
                if(totalqtshipped < 99){
                    part.Related_Account__c = actMap.get('High Volume');
                }else{
                    part.Related_Account__c = actMap.get('Low Volume');
                }
                partList.add(part);
            }
        } 
        if(!partList.isEmpty()){
            insert partList;
        }

        result ='success';
    }
        }catch(exception ex){
            result ='error';
        }
        return result;
  }
}