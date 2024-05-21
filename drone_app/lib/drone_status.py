import json
import random
from typing import Any, Type
from drone_status_pb2 import DroneStatus
from google.protobuf.json_format import MessageToJson
import base64


def get_random_enum_value(enum: Type[DroneStatus.Status]) -> DroneStatus.Status:
    values = list(enum.values())
    return random.choice(values)  # type: ignore


def lambda_handler(event: Any, context: Any) -> Any:
    drone_status = DroneStatus()

    if random.random() < 0.9:
        drone_status.general_status = DroneStatus.ALL_OK
    else:
        drone_status.general_status = get_random_enum_value(DroneStatus.Status)

    drone_status.speed_kmh = random.randint(5, 14)
    alt = random.randint(30, 34)
    drone_status.alt_above_ground = alt
    drone_status.alt_above_sea = alt + 692

    drone_status.suction_active = random.randint(0, 2) == 2
    # drone_status.i_am_falling_lol = random.randint(0, 4) == 4

    proximity = drone_status.proximity
    proximity.left = random.randint(0, 6) == 6
    proximity.right = random.randint(0, 6) == 6
    proximity.front = random.randint(0, 2) == 2
    proximity.back = random.randint(0, 9) == 9
    proximity.top = random.randint(0, 9) == 9
    proximity.bottom = random.randint(0, 9) == 9

    response_body = drone_status.SerializeToString()
    response_body_base64 = base64.b64encode(response_body).decode("utf-8")

    pbjson = MessageToJson(drone_status, indent=0)
    pbjson = json.dumps(json.loads(pbjson), indent=None, separators=(",", ":"))

    print(f"Returning data: {pbjson}")

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/octet-stream"},
        "body": response_body_base64,
        "isBase64Encoded": True,
    }
