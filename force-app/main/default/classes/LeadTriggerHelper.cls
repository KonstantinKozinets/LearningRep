public class LeadTriggerHelper {
	public static Boolean doNotRunTrigger = false;

    public static void setDoNotRunTrigger(){
        doNotRunTrigger = true;
    }

    public static void setShouldRunTrigger(){
        doNotRunTrigger = false;
    }

    public static Boolean shouldRunTrigger() {
        return !doNotRunTrigger;
    }
}