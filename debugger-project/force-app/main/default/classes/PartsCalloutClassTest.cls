@isTest
public class PartsCalloutClassTest {
 @isTest
    static void testCallout() {
        // Set up a mock HTTP response
        PartsSyncHttpCalloutMock mock = new PartsSyncHttpCalloutMock();
        Test.setMock(HttpCalloutMock.class, mock);
        // Call the method that makes the HTTP callout
        Test.startTest();
        String s = PartSyncController.syncParts();
        Test.stopTest();
    }
}