@isTest
private class CustomOrderCleanerTest {

    @TestSetup
    static void testSetup(){

        List<Contact> contacts = new List<Contact> {
            new Contact (FirstName = 'firstname', LastName = 'lastname'),
            new Contact (FirstName = 'lastname', LastName = 'firstname')
        };

        insert contacts;
        List<Custom_Order__c> cOrders = new List<Custom_Order__c>();

        for (Contact contact : contacts) {
            cOrders.add(new Custom_Order__c(Contact__c = contact.Id, Status__c = 'Draft'));
            cOrders.add(new Custom_Order__c(Contact__c = contact.Id, Status__c = 'Draft'));
            cOrders.add(new Custom_Order__c(Contact__c = contact.Id, Status__c = 'Not Draft'));
            cOrders.add(new Custom_Order__c(Contact__c = contact.Id, Status__c = 'Not Draft'));
        }

        insert cOrders;
    }

    @isTest
    private static void testCustomOrderCleaner() {
        String sch = '0 0 0 15 3 ? 2022';
        CustomOrderCleaner cleaner = new CustomOrderCleaner();

        Test.startTest();
        System.schedule('Deleting Draft Status Orders', sch, cleaner);
        System.assertEquals(8, [SELECT COUNT() FROM Custom_Order__c]);
        Test.stopTest();

        System.assertEquals(0, [SELECT COUNT() FROM Custom_Order__c WHERE Status__c = 'Draft']);
        System.assertEquals(4, [SELECT COUNT() FROM Custom_Order__c]);
    }

}