trigger LeadTrigger on Lead (after insert, after update) {
    if(LeadTriggerHelper.shouldRunTrigger()){
        LeadTriggerHandler.updateLeads(Trigger.new);
    }
}