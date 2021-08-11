public class LeadTriggerHandler {
    private static Map<String, Set<Campaign>> getCampaignParents {
        get {
            if (getCampaignParents == null) {
                getCampaignParents = new Map<String, Set<Campaign>>();

                Map<Id, Campaign> getCampaigns = new Map<Id, Campaign> ([
                    SELECT Name, StartDate, EndDate, ParentId
                    FROM Campaign
                ]);

                for (Campaign camp : getCampaigns.values()) {
                    if (getCampaigns.containsKey(camp.ParentId)) {
                        if (!getCampaignParents.containsKey(getCampaigns.get(camp.ParentId).Name)) {
                            getCampaignParents.put(getCampaigns.get(camp.ParentId).Name, new Set<Campaign> { camp });
                        } else if (getCampaignParents.containsKey(getCampaigns.get(camp.ParentId).Name)) {
                            getCampaignParents.get(getCampaigns.get(camp.ParentId).Name).add(camp);
                        }
                    }
                }
            }

            return getCampaignParents;
        }
        private set;
    }

    public static void updateLeads(List<Lead> leadsToUpdate) {
        Map<Lead, CampaignMember> connections = new Map<Lead, CampaignMember>();
        Integer errors = 0;
        for (Lead lead : leadsToUpdate) {
            if (getCampaignParents.containsKey(lead.LeadSource)) {
                for (Campaign camp : getCampaignParents.get(lead.LeadSource)) {
                    if (camp.StartDate <= lead.CreatedDate && lead.CreatedDate <= camp.EndDate) {
                        connections.put(lead, new CampaignMember(LeadId = lead.id, CampaignId = camp.Id));
                    }
                }
            }
        }

        for (Lead l : leadsToUpdate) {
            if (!connections.containsKey(l)) {
                l.addError('Campaign not exists for this LeadSource');
                errors++;
            }
        }

        if (errors == Integer.valueOf(0)) {
            insert connections.values();
        }
    }
}