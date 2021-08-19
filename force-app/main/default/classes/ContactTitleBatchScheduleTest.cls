@isTest
private class ContactTitleBatchScheduleTest {

    @TestSetup
    static void testSetup(){
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < 50; i++) {
            contacts.add(new Contact(FirstName = 'FirstJob', LastName = 'SecondJob'));
        }

        insert contacts;
    }

    @isTest
    static void testBatch() {
        Test.startTest();
        Id batchId = Database.executeBatch(new ContactTitleBatch(), 50);
        Test.stopTest();

        List<Contact> contacts = [
            SELECT Title
            FROM Contact
            WHERE FirstName = 'FirstJob' AND LastName = 'SecondJob'
        ];

        for (Contact c : contacts) {
            System.assertEquals('Async Apex', c.Title);
        }

        System.assertEquals(
            'Aborted',
            [SELECT Status FROM AsyncApexJob WHERE Id = :batchId].Status
        );
    }

    @isTest
    static void testBatchCallDelay() {
        String sch = '0 ' + DateTime.now().addMinutes(20).minute() + ' 0/1 1/1 * ? *';

        Test.startTest();
        CallBatch.call();
        Test.stopTest();

        for (Contact c : [SELECT Title FROM Contact]) {
            System.assertEquals(null, c.Title);
        }

        System.assertEquals(
            DateTime.now().addMinutes(19).addSeconds(60 - DateTime.now().second()),
            [SELECT NextFireTime FROM CronTrigger WHERE CronExpression = :sch LIMIT 1].NextFireTime
        );
    }
}