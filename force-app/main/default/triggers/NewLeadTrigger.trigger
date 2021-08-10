trigger NewLeadTrigger on Lead (after insert) {
    Set<Lead> leadsToUpdate = new Set<Lead>(Trigger.newMap.values());
    Map<Lead, CampaignMember> connections = NewLeadTriggerHandler.updateLeads(leadsToUpdate);
    Integer errors = 0;

    for (Lead l : Trigger.new) {
        if (!connections.containsKey(l)) {
            l.addError('Campaign not exists for this LeadSource');
            errors++;
        }
    }

    if (errors == Integer.valueOf(0)) {
        insert connections.values();
    }
}