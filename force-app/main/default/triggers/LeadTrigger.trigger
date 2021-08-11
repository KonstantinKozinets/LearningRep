trigger LeadTrigger on Lead (after insert, after update) {
    if ((Trigger.isAfter && Trigger.isInsert) || (Trigger.isAfter && Trigger.isUpdate)) {
        if (!LeadTriggerHelper.doNotRunTrigger){
            LeadTriggerHandler.updateLeads(Trigger.new);
        }
    }
}