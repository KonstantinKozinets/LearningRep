trigger AppointmentTrigger on Appointment__c (before insert, before update) {

	//For any inserting/updating Appointment

    for (Appointment__c a : Trigger.New) {

        // list of selected Doctor's Appointments
        List<Appointment__c> appc = [SELECT Name, Appointment_Date__c, Duration_in_minutes__c
                       				FROM Appointment__c
                       				WHERE Doctor__c = :a.Doctor__c];

        // for all Doctor's Appointments

        for (Appointment__c app : appc){

        // comparing new Appointment Date with existing Appointments Date's

            DateTime MeetEnd = app.Appointment_Date__c + (app.Duration_in_minutes__c/24/60);
         	if (a.Appointment_Date__c >= app.Appointment_Date__c && a.Appointment_Date__c <= MeetEnd )  {
				a.addError('This doctor can not meet you at this time. Please enter another date.');
			}
		}
	}
}