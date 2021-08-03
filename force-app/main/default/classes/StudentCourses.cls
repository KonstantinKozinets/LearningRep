global class StudentCourses implements Comparable {

    public String cName;
    public Double matchPercentage;

    public static Map<String, List<Preference__c>> getPreferences {
        get {
            if (getPreferences == null) {
                Map<Id, Preference__c> getStudents = new Map<Id, Preference__c>([
                    SELECT Name, Student__r.Name, Skill__c, Skill__r.Name
                    FROM Preference__c
                ]);

                getPreferences = new Map<String, List<Preference__c>>();

                for (Preference__c pref : getStudents.values()) {
                    if (!getPreferences.containsKey(pref.Student__r.Name)) {
                        getPreferences.put(pref.Student__r.Name, new List<Preference__c> {pref});
                    } else {
                        getPreferences.get(pref.Student__r.Name).add(pref);
                    }
                }
            }

            return getPreferences;
        }
        private set;
    }

    public static Map<String, List<Discipline__c>> getDisciplines {
        get {
            if (getDisciplines == null) {
                Map<Id, Discipline__c> getCourses = new Map<Id, Discipline__c>([
                    SELECT Name, Course__r.Name, Skill__c, Skill__r.Name
                    FROM Discipline__c
                ]);

                getDisciplines = new Map<String, List<Discipline__c>>();

                for (Discipline__c dis : getCourses.values()) {
                    if (!getDisciplines.containsKey(dis.Course__r.Name)) {
                        getDisciplines.put(dis.Course__r.Name, new List<Discipline__c> {dis});
                    } else {
                        getDisciplines.get(dis.Course__r.Name).add(dis);
                    }
                }
            }

            return getDisciplines;
        }
        private set;
    }

    public StudentCourses (String courseName, Double matchPercent){

        cName = courseName;
        matchPercentage = matchPercent;

    }

    global Integer compareTo(Object compareTo) {

        StudentCourses compareToStudentCourses = (StudentCourses)compareTo;

        if (matchPercentage > compareToStudentCourses.matchPercentage) {
            return -1;
        } else if (matchPercentage < compareToStudentCourses.matchPercentage) {
            return 1;
        } else {
            return 0;
        }
    }

    public static Double getMatchPercent(List<Discipline__c> disciplines, List<Preference__c> preferences) {

        Integer match = 0;
        List<Discipline__c> disc = New List<Discipline__c>(disciplines);
        List<Preference__c> prefs = New List<Preference__c>(preferences);

        for (Preference__c pref : prefs) {
            for (Discipline__c dis : disc) {
                if ((dis.Name.equals(pref.Name)) && (dis.Skill__r.Name.equals(pref.Skill__r.Name))) {
                    match++;
                }
            }
        }

        Double matchPercent = match / (prefs.size()) * 100;

        return matchPercent;
    }

    public static Map<String, List<StudentCourses>> getMatchPercent(List<Student__c> students){

        Map<String, List<StudentCourses>> resultMap = new Map<String, List<StudentCourses>>();

        for (Student__c student : students) {
            if (getPreferences.containsKey(student.Name)) {
                if (!resultMap.containsKey(student.Name)) {
                    resultMap.put(student.Name, new List<StudentCourses>());
                    for (String course : getDisciplines.keySet()) {
                        resultMap.get(student.Name).add(
                            new StudentCourses(course, getMatchPercent(getDisciplines.get(course), getPreferences.get(student.Name)))
                        );
                    }
                    resultMap.get(student.Name).sort();
                }
            }
        }

        return resultMap;
    }
}