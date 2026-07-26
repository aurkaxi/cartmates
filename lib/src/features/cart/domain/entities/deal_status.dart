enum DealStatus {
  recruiting('Recruiting'),
  interested('Interested'),
  hold('Hold'),
  confirmed('Confirmed'),
  ordered('Ordered'),
  arrived('Arrived'),
  completed('Completed');

  const DealStatus(this.label);

  final String label;

  static DealStatus fromString(String value) {
    return DealStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => DealStatus.recruiting,
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
