class ActivityOption {
  ActivityOption({required this.type, required this.icon, required this.color});
  final String type;
  final String icon;
  final String color;

  factory ActivityOption.fromJson(Map<dynamic, dynamic> data) {
    final type = data['type'] as String;
    final icon = data['icon'] as String;
    final color = data['color'] as String;
    return ActivityOption(type: type, icon: icon, color: color);
  }

  toJson() {
    return {
      'type': type,
      'icon': icon,
      'color': color,
    };
  }
}
