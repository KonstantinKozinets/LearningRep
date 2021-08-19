public class ContactTitleBatchSchedule implements Schedulable{

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new ContactTitleBatch(), 50);
    }
}