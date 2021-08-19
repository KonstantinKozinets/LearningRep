@isTest
private class ScheduledJobTest {
    private static String cron = '0 0 0 15 3 ? ' + Datetime.now().addYears(1).year();

    @TestSetup
    private static void testSetup() {
        List<Contact> contacts = new List<Contact> {
            new Contact (FirstName = 'FirstJob', LastName = 'Test1'),
            new Contact (FirstName = 'Test2', LastName = 'SecondJob')
        };

        insert contacts;
    }

    @isTest
    private static void testScheduledJobLaunch() {

        Test.startTest();

        StartScheduledJobs.startScheduledJobs();
        System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob WHERE Status = 'Queued']);
        StopScheduledJob.stopScheduledJob();
        System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob WHERE Status = 'Aborted']);

        Test.stopTest();
    }

    @isTest
    private static void testScheduledJobOrders() {
        Test.startTest();

        System.schedule('Order for Contacts', cron, new ScheduledJob());
        System.assertEquals(
            0,
            [SELECT COUNT() FROM Custom_Order__c],
            'Orders exist before job has run'
        );

        Test.stopTest();

        System.assertEquals(
            20,
            [SELECT COUNT() FROM Custom_Order__c WHERE Contact__c = :new List<Contact>([SELECT Id FROM Contact])]
        );
    }
}