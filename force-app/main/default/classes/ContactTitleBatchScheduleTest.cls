@isTest
private class ContactTitleBatchScheduleTest {

    @TestSetup
    static void testSetup(){
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < 50; i++) {
            contacts.add(new Contact(FirstName = 'FirstJob', LastName = 'LastJob'));
        }

        insert contacts;
    }

    @isTest
    static void testBatch() {
        String sch =
            DateTime.now().second() +
            ' ' + DateTime.now().addMinutes(20).minute() +
            ' 0/1 1/1 * ? *';
        ContactTitleBatch updateContactsBatch = new ContactTitleBatch(sch);
        Test.startTest();
        Id batchId = Database.executeBatch(updateContactsBatch, 50);
        Test.stopTest();

        for (Contact c : [SELECT Title FROM Contact]) {
            System.assertEquals('Async Apex', c.Title);
        }
        System.assertEquals(
            'Aborted',
            [SELECT Status FROM AsyncApexJob WHERE Id = :batchId].Status
        );

    }

    @isTest
    static void testBatchCallDelay() {
        String sch =
            DateTime.now().second() +
            ' ' + DateTime.now().addMinutes(20).minute() +
            ' 0/1 1/1 * ? *';

        Test.startTest();
        CallBatch.call();
        Test.stopTest();

        for (Contact c : [SELECT Title FROM Contact]) {
            System.assertEquals(null, c.Title);
        }

        System.assertEquals(DateTime.now().addMinutes(20),[
            SELECT NextFireTime
            FROM CronTrigger
            WHERE CronExpression = :sch
            LIMIT 1
        ].NextFireTime);
    }
}