trigger LeadTrigger on Lead (after insert, after update) {
    if(LeadTriggerHelper.shouldRunTrigger()){
        LeadTriggerHandler.updateLeads(new Set<Lead>(Trigger.newMap.values()));
    }
}