public class StopScheduledJob {

    @InvocableMethod
    public static void stopScheduledJob() {

        List<CronTrigger> jobToAbort = [
            SELECT Id
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Create Orders for Contacts'
            LIMIT 1
        ];

        if (!jobToAbort.isEmpty()) {
            System.abortJob(jobToAbort[0].Id);
        }

    }
}