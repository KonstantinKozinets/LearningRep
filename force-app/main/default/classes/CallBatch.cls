public class CallBatch {
    public static void call() {
        System.schedule(
            'Updating Contacts Batch',
            '0 ' + DateTime.now().addMinutes(20).minute() + ' 0/1 1/1 * ? *',
            new ContactTitleBatchSchedule()
        );
    }
}