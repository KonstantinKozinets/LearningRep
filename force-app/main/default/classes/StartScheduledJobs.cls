global class StartScheduledJobs {
    public static String jobID {get; set;}

    @InvocableMethod
    public static void StartScheduledJobs() {
        ScheduledJob schJob = new ScheduledJob();
        String sch = '0 0 0/1 1/1 * ? *';
        jobID = System.schedule('Create Orders for Contacts', sch, schJob);
    }

}