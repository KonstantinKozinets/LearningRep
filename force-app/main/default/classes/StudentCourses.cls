public class StudentCourses {

    public class StudentCourse implements Comparable {
        public String cName;
        public Double matchPercentage;

        public StudentCourse (String courseName, Decimal matchPercent) {
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

    public static Set<Id> students;

    public static Map<String, Set<Id>> getPreferences {
        get {
            if (getPreferences == null) {
                Map<Id, Preference__c> preferences = new Map<Id, Preference__c>([
                    SELECT Student__c, Student__r.Name, Skill__c
                    FROM Preference__c
                    WHERE Student__c IN :students
                ]);
                getPreferences = new Map<String, Set<Id>>();

                for (Preference__c preference : preferences.values()) {
                    if (!getPreferences.containsKey(preference.Student__r.Name)) {
                        getPreferences.put(preference.Student__r.Name, New Set<Id> { preference.Skill__c });
                    } else {
                        getPreferences.get(preference.Student__r.Name).add(preference.Skill__c);
                    }
                }
            }

            return getPreferences;
        }
        private set;
    }

    public static Map<String, Set<Id>> getDisciplines {
        get {
            if (getDisciplines == null) {
                Map<Id, Discipline__c> disciplines = new Map<Id, Discipline__c>([
                    SELECT Course__r.Name, Skill__c
                    FROM Discipline__c
                    WHERE Course__c != NULL
                ]);

                getDisciplines = new Map<String, Set<Id>>();

                for (Discipline__c discipline : disciplines.values()) {
                    if (!getDisciplines.containsKey(discipline.Course__r.Name)) {
                        getDisciplines.put(discipline.Course__r.Name, New Set<Id> { discipline.Skill__c });
                    } else {
                        getDisciplines.get(discipline.Course__r.Name).add(discipline.Skill__c);
                    }
                }
            }
            return getDisciplines;
        }
        private set;
    }

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

    public static Decimal getMatchPercent(String course, String student) {
        Set<Id> disciplines = getDisciplines.get(course);
        Set<Id> preferences = getPreferences.get(student);
        Decimal matchPercent = 0;

        for (Id discipline : disciplines) {
            if (preferences.contains(discipline)) {
                matchPercent++;
            }
        }

        matchPercent = matchPercent / preferences.size() * 100;

        return matchPercent.setScale(2);
    }
}