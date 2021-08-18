public class CallBatch {
    public static void call() {
        String sch = (
            '0 ' + DateTime.now().addMinutes(20).minute() +
            ' 0/1 1/1 * ? *'
        );
        ContactTitleBatchSchedule batchSchedule = new ContactTitleBatchSchedule();
        String jobID = System.schedule('Updating Contacts Batch', sch, batchSchedule);
    }
}