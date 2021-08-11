public class LeadTriggerHandler {
    private static Map<String, Set<Campaign>> getCampaignParents(Set<Integer> createdDatesYears, Set<Integer> createdDatesMonths) {
        if (CampaignParents == null) {
            CampaignParents = new Map<String, Set<Campaign>>();

            Map<Id, Campaign> getCampaigns = new Map<Id, Campaign> ([
                SELECT Name, StartDate, EndDate, ParentId
                FROM Campaign
                WHERE CALENDAR_YEAR(StartDate) IN :createdDatesYears AND
                    CALENDAR_MONTH(StartDate) IN :createdDatesMonths
            ]);

            for (Campaign camp : getCampaigns.values()) {
                if (getCampaigns.containsKey(camp.ParentId)) {
                    if (!CampaignParents.containsKey(getCampaigns.get(camp.ParentId).Name)) {
                        CampaignParents.put(getCampaigns.get(camp.ParentId).Name, new Set<Campaign> { camp });
                    } else if (CampaignParents.containsKey(getCampaigns.get(camp.ParentId).Name)) {
                        CampaignParents.get(getCampaigns.get(camp.ParentId).Name).add(camp);
                    }
                }
            }
        }
        return CampaignParents;
    }

    public static Set<Integer> createdDatesYears ;
    public static Set<Integer> createdDatesMonths;
    private static Map<String, Set<Campaign>> campaignParents;

    public static void updateLeads(List<Lead> leadsToUpdate) {
        Map<Lead, CampaignMember> connections = new Map<Lead, CampaignMember>();
        Integer errors = 0;

        for (Lead l : leadsToUpdate) {
            createdDatesYears.add(l.CreatedDate.date().year());
            createdDatesMonths.add(l.CreatedDate.date().month());
        }
        campaignParents = getCampaignParents(createdDatesYears, createdDatesMonths);
        for (Lead lead : leadsToUpdate) {
            if (campaignParents.containsKey(lead.LeadSource)) {
                for (Campaign camp : campaignParents.get(lead.LeadSource)) {
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