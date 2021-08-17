public class ChainJobSchedule implements Schedulable {
    public void execute(SchedulableContext ctx) {
        ContactFirstName firstName = new ContactFirstName();
        Id batchId = System.enqueueJob(firstName);
    }
}