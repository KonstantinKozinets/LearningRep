public class StartScheduledJobs {

    @InvocableMethod
    public static void startScheduledJobs() {
        System.schedule('Create Orders for Contacts', '0 0 0/1 1/1 * ? *', new ScheduledJob());
    }
}