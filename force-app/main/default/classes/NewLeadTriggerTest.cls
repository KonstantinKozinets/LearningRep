@isTest
private class NewLeadTriggerTest {

    @testSetup
    private static void testSetup() {
        Campaign parentCampaign = new Campaign(
            Name = '2021 Campaign for Task',
            StartDate = Date.newInstance(2021, 1, 1),
            EndDate = Date.newInstance(2021, 12, 31)
        );
        insert parentCampaign;

        List<Campaign> childCampaigns = new List<Campaign> {
            new Campaign(
                Name = '2021 August Campaign',
                StartDate = Date.newInstance(2021, 8, 1),
                EndDate = Date.newInstance(2021, 8, 31),
                ParentId = parentCampaign.Id
            ), new Campaign(
                Name = '2021 September Campaign',
                StartDate = Date.newInstance(2021, 9, 1),
                EndDate = Date.newInstance(2021, 9, 30),
                ParentId = parentCampaign.Id
            )
        };
        insert childCampaigns;
    }

    @isTest
    private static void testNewLeadTriggerHandler() {
        Lead winLead = new Lead(LastName = 'Win Test', Company = 'Test', LeadSource = '2021 Campaign for Task');
        Lead loseLead = new Lead(LastName = 'Loss Test', Company = 'Test', LeadSource = 'Test');

        Test.startTest();
        insert winLead;
        try {
            insert loseLead;
        } catch (DmlException e) {
            //Assert Error Message
            System.assert( e.getMessage().contains('Campaign not exists for this LeadSource'),
                e.getMessage() );
        }
        Test.stopTest();

        List<CampaignMember> campaignMembers = [SELECT LeadId, CampaignId FROM CampaignMember];
        System.assertEquals(1, campaignMembers.size());
    }
}