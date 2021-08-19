public class StopScheduledJob {

    @InvocableMethod
    public static void stopScheduledJob() {
        CronTrigger jobToAbort = [
            SELECT Id
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Create Orders for Contacts'
            LIMIT 1
        ];

        if (!String.isEmpty(jobToAbort.Id)) {
            System.abortJob(jobToAbort.Id);
        }

    }
}