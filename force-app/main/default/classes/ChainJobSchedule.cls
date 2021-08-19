public class ChainJobSchedule implements Schedulable {
    public void execute(SchedulableContext ctx) {
        System.enqueueJob(new ContactFirstName());
    }
}