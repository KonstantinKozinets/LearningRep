@isTest
private class ScheduledJobTest {
    private static String cron = '0 0 0 15 3 ? 2022';

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

        StartScheduledJobs.StartScheduledJobs();
        System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob WHERE Status = 'Queued']);
        StopScheduledJob.stopScheduledJob();
        System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob WHERE Status = 'Aborted']);

        Test.stopTest();


    }

    @isTest
    private static void testScheduledJobOrders() {
        Test.startTest();

        String jobId = System.schedule(
            'Order for Contacts',
            cron,
            new ScheduledJob()
        );

        System.assertEquals(
            0,
            [SELECT COUNT() FROM Custom_Order__c],
            'Orders exist before job has run'
        );

        Test.stopTest();

        for (Contact c : [SELECT Id FROM Contact]) {
            System.assertEquals(
                10,
                [SELECT COUNT() FROM Custom_Order__c WHERE Contact__c = : c.Id]
            );
        }
    }
}