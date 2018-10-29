
首先需要在plist里面添加如下字段
<key>NSFaceIDUsageDescription</key>
<string>允许设备访问FaceID</string>

否则会奔溃，和使用相机需要添加描述字段是一样的
