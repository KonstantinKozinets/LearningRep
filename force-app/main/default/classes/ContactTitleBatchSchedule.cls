global class ContactTitleBatchSchedule implements Schedulable{

    global void execute(SchedulableContext ctx) {
        ContactTitleBatch updateContactsBatch = new ContactTitleBatch();
        Id batchId = Database.executeBatch(updateContactsBatch, 50);
    }
}