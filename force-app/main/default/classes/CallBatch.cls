public class CallBatch {
    public static void call() {
        String sch = (
            DateTime.now().second() +
            ' ' + DateTime.now().addMinutes(20).minute() +
            ' 0/1 1/1 * ? *'
        );
        ContactTitleBatchSchedule batchSchedule = new ContactTitleBatchSchedule();
        String jobID = System.schedule('Updating Contacts Batch', sch, batchSchedule);
    }
}