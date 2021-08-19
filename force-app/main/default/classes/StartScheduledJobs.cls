public class StartScheduledJobs {

    @InvocableMethod
    public static void startScheduledJobs() {

        List<CronTrigger> jobToStart = [
            SELECT Id
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Create Orders for Contacts'
            LIMIT 1
        ];

        if (jobToStart.isEmpty()) {
            System.schedule('Create Orders for Contacts', '0 0 0/1 1/1 * ? *', new ScheduledJob());
        }
    }
}