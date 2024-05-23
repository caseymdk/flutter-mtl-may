# Flutter & Protobuf

This is the code shown during my Flutter Montreal presentation on May 22, 2024.
https://www.youtube.com/live/6VpGWm6nIhY?si=hcqPY-aKPWLXVwzP&t=5790

# How to use / demo

1. The app will build as is with the local DroneStatus Dart class.
2. Delete drone_status_class.dart, `cd lib` and run `protoc --dart_out . drone_status.proto`.
3. Delete the imports for `drone_status_class.dart`, and import `drone_status.pb.dart`.
4. App will run / build using the protobuf generated classes.
5. Run `protoc --python_out . --pyi_out . drone_status.proto` to create the python classes needed for drone_status.proto to run.
6. Create an AWS Lambda function, enabling the function URL under "Configuration".
7. Copy the `drone_status_pb2.py` file into the lambda function, and populate `lambda_function.py` with the contents of `drone_status.py`.
8. Delete `_updateDroneStatus()` and uncomment `fetchDroneStatus()`
9. Replace `<LAMBDA_URL>` in the code with the function URL of the deployed lambda
10. Watch the app work as it now fetches the values from the remote Lambda URL
11. Try performing the changes in the comments of `drone_status.proto`, re-running `protoc` and try integrating them in one, the other, and both environments (Dart / Python). See how it works!