public class LeadTriggerHelper {
	public static Boolean doNotRunTrigger {
        get {
            if (doNotRunTrigger == null) {
                doNotRunTrigger = false;
            }
            return doNotRunTrigger;
        }
        set;
    }
}