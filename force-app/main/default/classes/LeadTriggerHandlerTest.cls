@isTest
public class LeadTriggerHandlerTest {

    @testSetup
    private static void testSetup() {
        Campaign parentCampaign = new Campaign(
            Name = '2021 Campaign for Task',
            StartDate = Date.newInstance(2021, 1, 1),
            EndDate = Date.newInstance(2021, 12, 31)
        );
        insert parentCampaign;

        Campaign augustCampaign = new Campaign(
            Name = '2021 August Campaign',
            StartDate = Date.newInstance(2021, 8, 1),
            EndDate = Date.newInstance(2021, 8, 31),
            ParentId = parentCampaign.Id
        );

        Campaign septemberCampaign = new Campaign(
            Name = '2021 September Campaign',
            StartDate = Date.newInstance(2021, 9, 1),
            EndDate = Date.newInstance(2021, 9, 30),
            ParentId = parentCampaign.Id
        );

        insert new List<Campaign>{ augustCampaign, septemberCampaign };
    }

    @isTest
    private static void testLeadTriggerHandler() {
        Lead winLead = new Lead(LastName = 'Win Test', Company = 'Create Test', LeadSource = '2021 Campaign for Task');
        Lead loseLead = new Lead(LastName = 'Loss Test', Company = 'Test', LeadSource = 'Test');

        Test.startTest();
        Lead existingLead = new Lead(LastName = 'Existing Test', Company = 'Update Test', LeadSource = '2021 Campaign for Task');

        LeadTriggerHelper.doNotRunTrigger = true;
        insert existingLead;
        LeadTriggerHelper.doNotRunTrigger = false;

        Campaign septemberCampaign = [SELECT Name, StartDate, EndDate, ParentId
                                      FROM Campaign
                                      WHERE Name = '2021 September Campaign'];

        System.assertEquals('2021 Campaign for Task', existingLead.LeadSource);

        update existingLead;

        Campaign excm = [SELECT Name
                         FROM Campaign
                         WHERE Id IN (SELECT CampaignId
                                      FROM CampaignMember
                                      WHERE LeadId = :existingLead.Id)];
        String cm = excm.Name;

        System.assertEquals('2021 August Campaign', cm);

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
        System.assertEquals(2, campaignMembers.size());
    }
}