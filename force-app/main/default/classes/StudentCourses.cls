public class StudentCourses {

    private static Set<Id> students;

    private static Map<String, Set<Id>> getPreferences {
        get {
            if (getPreferences == null) {
                Map<Id, Skill2__c> skills = new Map<Id, Skill2__c> ([
                    SELECT (SELECT Student__c, Student__r.Name, Skill__c
                            FROM Preferences__r), (SELECT Course__r.Name, Skill__c
                                                   FROM Disciplines__r)
                    FROM Skill2__c
                    WHERE Id IN (SELECT Skill__c
                                 FROM Preference__c
                                 WHERE Student__C IN :students)
                ]);

                getPreferences = new Map<String, Set<Id>>();
                getDisciplines = new Map<String, Set<Id>>();

                for (Skill2__c skill : skills.values()) {
                    for (Preference__c preference : skill.Preferences__r) {
                        if (!getPreferences.containsKey(preference.Student__r.Name)) {
                            getPreferences.put(preference.Student__r.Name, New Set<Id> { preference.Skill__c });
                        } else {
                            getPreferences.get(preference.Student__r.Name).add(preference.Skill__c);
                        }
                    }

                    for (Discipline__c discipline : skill.Disciplines__r) {
                        if (!getDisciplines.containsKey(discipline.Course__r.Name)) {
                            getDisciplines.put(discipline.Course__r.Name, New Set<Id> { discipline.Skill__c });
                        } else {
                            getDisciplines.get(discipline.Course__r.Name).add(discipline.Skill__c);
                        }
                    }
                }
            }

            return getPreferences;
        }
        private set;
    }

    private static Map<String, Set<Id>> getDisciplines { get; private set; }

    public static Map<String, List<StudentCourse>> getMatchPercent(List<Student__c> listStudents) {
        students = new Map<Id, Student__c>(listStudents).keySet();
        Map<String, List<StudentCourse>> resultMap = new Map<String, List<StudentCourse>>();

        for (Student__c student : listStudents) {
            if (getPreferences.containsKey(student.Name)) {
                resultMap.put(student.Name, new List<StudentCourse>());

                for (String course : getDisciplines.keySet()) {
                    resultMap.get(student.Name).add(
                        new StudentCourse(course, getMatchPercent(course, student.Name))
                    );
                }

                resultMap.get(student.Name).sort();
            }
        }

        return resultMap;
    }

    private static Decimal getMatchPercent(String course, String student) {
        Set<Id> disciplines = getDisciplines.get(course);
        Set<Id> preferences = getPreferences.get(student);

        Set<Id> matches = disciplines.clone();
        matches.retainAll(preferences);

        Decimal matchPercent = matches.size() / preferences.size() * 100;

        return matchPercent.setScale(2);
    }

    @TestVisible private class StudentCourse implements Comparable {
        public String cName;
        public Double matchPercentage;

        public StudentCourse(String courseName, Decimal matchPercent) {
            cName = courseName;
            matchPercentage = matchPercent;
        }

        public Integer compareTo(Object compareTo) {
            StudentCourse compareToStudentCourse = (StudentCourse)compareTo;

            if (matchPercentage > compareToStudentCourse.matchPercentage) {
                return -1;
            } else if (matchPercentage < compareToStudentCourse.matchPercentage) {
                return 1;
            } else {
                return 0;
            }
        }
    }
}