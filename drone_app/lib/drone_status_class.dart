class DroneStatus {
  final DroneStatus_Status? generalStatus;
  final int? speedKmh;
  final int? altAboveGround;
  final int? altAboveSea;
  final bool? suctionActive;
  final DroneStatus_ProximityStatus? proximity;

  DroneStatus({
    this.generalStatus,
    this.speedKmh,
    this.altAboveGround,
    this.altAboveSea,
    this.suctionActive,
    this.proximity,
  });
}

class DroneStatus_ProximityStatus {
  final bool? left;
  final bool? right;
  final bool? front;
  final bool? back;
  final bool? top;
  final bool? bottom;

  DroneStatus_ProximityStatus({
    this.left,
    this.right,
    this.front,
    this.back,
    this.top,
    this.bottom,
  });
}

enum DroneStatus_Status {
  ALL_OK,
  // Add other statuses as needed
}
