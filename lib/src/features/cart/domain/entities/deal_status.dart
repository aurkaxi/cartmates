enum DealStatus {
  recruiting('Recruiting'),
  ready('Ready'),
  ordered('Ordered'),
  arrived('Arrived'),
  completed('Completed'),
  expired('Expired'),
  cancelled('Cancelled');

  const DealStatus(this.label);
  final String label;
}

enum ParticipantStatus {
  // Passive (joined) statuses
  hold('Hold'),
  confirmed('Confirmed'),
  denied('Denied'),
  disputed('Disputed'),
  // Shared statuses
  ordered('Ordered'),
  arrived('Arrived'),
  completed('Completed'),
  expired('Expired');

  const ParticipantStatus(this.label);
  final String label;

  static ParticipantStatus fromString(String value) {
    return ParticipantStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => ParticipantStatus.hold,
    );
  }
}

enum CartTab { passive, active }

extension CartTabX on CartTab {
  String get label => switch (this) {
        CartTab.passive => 'Passive (Joined)',
        CartTab.active => 'Active (Hosting)',
      };
}
