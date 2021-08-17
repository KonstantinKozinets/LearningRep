@isTest
private class ChainJobScheduleTest {

    @isTest
    static void testChainJobSchedule() {
        Test.startTest();
        Id jobId = System.schedule(
            'ScheduledJobTest',
            '0 0 0 15 3 ? 2022',
            new ChainJobSchedule()
        );
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM CronTrigger WHERE Id = :jobId]);
    }

    @isTest
    static void testChainFirstJob() {
        ContactFirstName cf = new ContactFirstName();

        test.startTest();
        System.enqueueJob(cf);
        test.stopTest();

        for (Contact con : cf.contacts) {
            System.assertEquals('FirstJob', con.FirstName);
            System.assert('SecondJob' != con.LastName);
        }
    }

    @isTest
    static void testChainSecondJob() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(FirstName = 'FirstJob', LastName = 'Test' + i));
        }

        Test.startTest();
        System.enqueueJob(new ContactSecondName(contacts));
        Test.stopTest();

        System.assertEquals(200, [
            SELECT COUNT()
            FROM Contact
            WHERE FirstName = 'FirstJob' AND LastName = 'SecondJob'
        ]);
    }
}