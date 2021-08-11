public class LeadTriggerHandler {
    public static void updateLeads(List<Lead> leadsToUpdate) {
        Map<Id, CampaignMember> connections = new Map<Id, CampaignMember>();
        Integer errors = 0;
        Set<Integer> createdDatesYears = new Set<Integer>();
        Set<Integer> createdDatesMonths = new Set<Integer>();

        for (Lead l : leadsToUpdate) {
            createdDatesYears.add(l.CreatedDate.date().year());
            createdDatesMonths.add(l.CreatedDate.date().month());
        }

        Map<String, Set<Campaign>> campaignParents = getCampaignParents(
            createdDatesYears,
            createdDatesMonths
        );

        for (Lead lead : leadsToUpdate) {
            if (campaignParents.containsKey(lead.LeadSource)) {
                for (Campaign camp : campaignParents.get(lead.LeadSource)) {
                    if (camp.StartDate <= lead.CreatedDate && lead.CreatedDate <= camp.EndDate) {
                        connections.put(lead.Id, new CampaignMember(LeadId = lead.id, CampaignId = camp.Id));
                    }
                }
            }
        }

        for (Lead l : leadsToUpdate) {
            if (!connections.containsKey(l.Id)) {
                l.addError('Campaign not exists for this LeadSource');
                errors++;
            }
        }

        if (errors == 0) {
            insert connections.values();
        }
    }

    private static Map<String, Set<Campaign>> getCampaignParents(
        Set<Integer> createdDatesYears,
        Set<Integer> createdDatesMonths
    ) {
        Map<String, Set<Campaign>> campaignParents = new Map<String, Set<Campaign>>();

        Map<Id, Campaign> getCampaigns = new Map<Id, Campaign>([
            SELECT Name, StartDate, EndDate, Parent.Name
            FROM Campaign
            WHERE CALENDAR_YEAR(StartDate) IN :createdDatesYears AND
                CALENDAR_MONTH(StartDate) IN :createdDatesMonths
        ]);

        for (Campaign camp : getCampaigns.values()) {
            if (!campaignParents.containsKey(camp.Parent.Name)) {
                campaignParents.put(camp.Parent.Name, new Set<Campaign> { camp });
            } else if (campaignParents.containsKey(camp.Parent.Name)) {
                campaignParents.get(camp.Parent.Name).add(camp);
            }
        }

        return campaignParents;
    }
}