import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2

import QtQuick.Scene3D 2.0

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

import QtQuick 2.11
import QtQuick.Layouts 1.3

ApplicationWindow
{
    visible: true
    width: 640
    height: 480
    title: qsTr("3D Viewer")

    header: ToolBar
    {
        ToolButton
        {
            text: "Open 3D Model"
            onPressed:
            {
                fileDialog.open()
            }
        }
    }

    FileDialog
    {
        id: fileDialog
        onAccepted:
        {
            sceneLoader.source = fileDialog.fileUrl
        }
    }

    Scene3D
    {
        anchors.fill: parent

        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

        Entity
        {
            id: sceneRoot

            Camera
            {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 30
                aspectRatio: 16/9
                nearPlane : 0.1
                farPlane : 1000.0
                position: Qt.vector3d( 10.0, 0.0, 0.0 )
                upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
            }

            FirstPersonCameraController
            {
                camera: camera
                linearSpeed: 500.0
                acceleration: 0.1
                deceleration: 1.0
            }

            Entity
            {
                components: [
                PointLight {},
                    Transform { translation: camera.position }
                ]
            }

            components: [
                RenderSettings
                {
                    activeFrameGraph: ForwardRenderer
                    {
                        clearColor: Qt.rgba(0, 0.5, 1, 1)
                        camera: camera
                    }
                    pickingSettings.pickMethod: PickingSettings.TrianglePicking
                    pickingSettings.faceOrientationPickingMode: pickingSettings.FrontAndBackFace
                },
                InputSettings
                {
                }
            ]

            Entity
            {
                id: monkeyEntity
                components: [
                    SceneLoader
                    {
                        id: sceneLoader
                    },
                    Transform
                    {
                        rotationX: rot_x.value
                        rotationY: rot_y.value
                        rotationZ: rot_z.value
                    },
                    ObjectPicker
                    {
                        onPressed: {
                            console.log("Object clicked! Pressed at world-intersection: ", pick.worldIntersection)
                        }
                    }

                ]
            }
        }
    }
    ColumnLayout
        {
            id: rot_xyz
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: parent.width * 0.25
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.top: scene3D.top
            spacing: 5

            Text { text: "Object"; font.bold: true }
            Text { text: "Rotation" }
            RowLayout {
                Text { text: "X" }
                Slider {
                    id: rot_x
                    Layout.fillWidth: true
                    from: 0
                    to: 360
                    value: 0
                }
            }
            RowLayout {
                Text { text: "Y" }
                Slider {
                    id: rot_y
                    Layout.fillWidth: true
                    from: 0
                    to: 360
                    value: 0
                }
            }
            RowLayout {
                Text { text: "Z" }
                Slider {
                    id: rot_z
                    Layout.fillWidth: true
                    from: 0
                    to: 360
                    value: 0
                }
            }
        }
}
