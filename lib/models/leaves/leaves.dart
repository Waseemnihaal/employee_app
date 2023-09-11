// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Leaves {
  String reason;
  // DateTime startDate;
  // DateTime endDate;
//DateTime appliedDate;
  String appliedDate;
  String date;
  LeaveType leaveType;
  LeaveStatus status;
  String? name;
  String? email;

  Leaves({
    required this.reason,
    required this.appliedDate,
    required this.date,
    required this.leaveType,
    required this.status,
    this.name,
    this.email,
  });

  Leaves copyWith({
    String? reason,
    String? appliedDate,
    String? date,
    LeaveType? leaveType,
    LeaveStatus? status,
    String? name,
    String? email,
  }) {
    return Leaves(
      reason: reason ?? this.reason,
      appliedDate: appliedDate ?? this.appliedDate,
      date: date ?? this.date,
      leaveType: leaveType ?? this.leaveType,
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reason': reason,
      'appliedDate': appliedDate,
      'Date': date,
      'leaveType': '',
      'status': '',
      'name': name,
      'email': email,
    };
  }

  factory Leaves.fromMap(Map<String, dynamic> map) {
    LeaveStatus mapLeaveStatus(String status) {
      switch (status) {
        case 'Accepted':
          return LeaveStatus.accepted;
        case 'Rejected':
          return LeaveStatus.declined;
        default:
          return LeaveStatus.pending;
      }
    }

    LeaveType mapLeaveType(String status) {
      switch (status) {
        case 'Casual Leave':
          return LeaveType.casual;
        default:
          return LeaveType.sick;
      }
    }

    return Leaves(
      reason: map['reason'] as String,
      appliedDate: map['appliedDate'] as String,
      date: map['Date'] as String,
      leaveType: mapLeaveType(map['LeaveType']),
      status: mapLeaveStatus(map['status']),
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Leaves.fromJson(String source) =>
      Leaves.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Leaves(reason: $reason, appliedDate: $appliedDate, Date: $date, leaveType: $leaveType, status: $status, name: $name, email: $email)';
  }

  @override
  bool operator ==(covariant Leaves other) {
    if (identical(this, other)) return true;

    return other.reason == reason &&
        other.appliedDate == appliedDate &&
        other.date == date &&
        other.leaveType == leaveType &&
        other.status == status &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return reason.hashCode ^
        appliedDate.hashCode ^
        date.hashCode ^
        leaveType.hashCode ^
        status.hashCode ^
        name.hashCode ^
        email.hashCode;
  }
}

enum LeaveType {
  casual('Casual Leave'),
  sick('Sick Leave');

  final String result;
  const LeaveType(this.result);
}

enum LeaveStatus {
  accepted('Accepted'),
  pending('Pending'),
  declined('Rejected');

  final String result;
  const LeaveStatus(this.result);
}
