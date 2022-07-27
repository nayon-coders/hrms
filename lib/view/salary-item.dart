// class Payslip {
//   final String name;
//   final String position;
//   final String gSalary;
//   final String nSalary;
//   final String mSalary;
//   final String hrm;
//   final String da;
//   final String ta;
//   final String mAllowance;
//   final String cAllowance;
//   final String sAllowance;
//   int amount = 0;
//
//   Payslip(this.name, this.position, this.gSalary, this.nSalary, this.mSalary, this.hrm, this.da, this.ta, this.mAllowance, this.cAllowance, this.sAllowance);
//
//
//
// }


class Payslip {
  String name;
  String dg;
  String grossSalary;
  String netPayble;
  String salaryMonth;
  String status;
  String basicPay;
  String hra;
  String da;
  String ta;
  String medicalAllowance;
  String cityAllowance;
  String specialAllowance;
  String ait;
  String providentFund;
  String gratuity;
  String advanceSalary;
  String createdAt;

  Payslip(
      this.name,
      this.dg,
      this.grossSalary,
      this.netPayble,
      this.salaryMonth,
      this.status,
      this.basicPay,
      this.hra,
      this.da,
      this.ta,
      this.medicalAllowance,
      this.cityAllowance,
      this.specialAllowance,
      this.ait,
      this.providentFund,
      this.gratuity,
      this.advanceSalary,
      this.createdAt,
      );
}


