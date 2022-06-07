class APIService{
    static const String baseUrl = "https://asia.net.in/api";
    static const String loginUrl = baseUrl + "/login";
    static const String logoutUrl = baseUrl + "/logout";
    static const String clockInUrl = baseUrl + "/attendanceemployee/clock_in";
    static const String clockOutUrl = baseUrl + "/attendanceemployee/clock_out";
    static const String attendanceListURL = baseUrl + "/attendanceemployee";
    static const String todayAttendanceListURL = baseUrl + "/todays/attendance";
    static const String profileUrl = "$baseUrl/profile";
    static const String updateProfileUrl = "$baseUrl/edit/profile";
    static const String updateChangePassUrl = "$baseUrl/update/password";
    static const String leaveTypeUrl = "$baseUrl/leave/type";
    static const String leaveRequestUrl = "$baseUrl/leave/store";
    static const String leaveListUrl = "$baseUrl/leave/index";
    static const String leaveCount = "$baseUrl/leave/count";
    static const String regularizationList = "$baseUrl/regularization/index";
    static const String getInOutClockTime = "$baseUrl/get_in_out";
    static const String addRegularaigetion = "$baseUrl/regularization/store";
}