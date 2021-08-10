public class NewLeadTriggerHandler {

    private static Map<String, Set<Campaign>> getCampaignParents {
        get {
            if (getCampaignParents == null) {
                getCampaignParents = new Map<String, Set<Campaign>>();

                Map<Id, Campaign> getCampaigns = new Map<Id, Campaign> ([
                    SELECT Name, StartDate, EndDate, ParentId
                    FROM Campaign
                    WHERE ParentId != NULL
                ]);

                List<Id> parents = new List<Id>();

                for (Campaign c : getCampaigns.values()){
                    if(!getCampaigns.containsKey(c.ParentId)){
                        parents.add(c.ParentId);
                    }
                }

                if (!parents.isEmpty()) {
                    getCampaigns.putAll(new Map<Id, Campaign>([
                        SELECT Name, StartDate, EndDate, ParentId
                        FROM Campaign
                        WHERE Id IN :parents
                    ]));
                }

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

    public static Map<Lead, CampaignMember> updateLeads(Set<Lead> leadsToUpdate) {
        Map<Lead, CampaignMember> connections = new Map<Lead, CampaignMember>();
        for (Lead lead : leadsToUpdate) {
            if (getCampaignParents.containsKey(lead.LeadSource)) {
                for (Campaign camp : getCampaignParents.get(lead.LeadSource)) {
                    if (camp.StartDate <= Date.today() && Date.today() <= camp.EndDate) {
                        connections.put(lead, new CampaignMember(LeadId = lead.id, CampaignId = camp.Id));
                    }
                }
            }
        }

        return connections;
    }

}