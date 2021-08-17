global class CustomOrderCleaner implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Custom_Order__c> ordersToDelete = [
            SELECT Id
            FROM Custom_Order__c
            WHERE Status__c = 'Draft'
        ];

        delete ordersToDelete;
    }
}