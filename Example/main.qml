import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")


    Xchart{
        id:xchart
        width:parent.width
        anchors.left: parent.left
        anchors.leftMargin: 10
        height:parent.height
        line:[{x:[0],y:[0],linewidth:1,color:"blue",selected:false,viewAllow:true,dragAllow:false,}]
    }

    Timer{
        id:timer
        interval:10
        repeat : true
        running : true
        onTriggered: {
            var j;
            var tx=new Array()
            var ty1=new Array()
            var ty2=new Array()
            for (j=0;j<2000;j++)
            {
                tx[j]=j
                ty1[j]=Math.random()*500+20000
                ty2[j]=Math.random()*200+40000
            }
            xchart.line=[{x:tx,y:ty1,linewidth:1,color:"blue",selected:false,viewAllow:true,dragAllow:false,},
                         {x:tx,y:ty2,linewidth:1,color:"red",selected:false,viewAllow:true,dragAllow:false,},
                    ]
            xchart.plot.requestPaint()
        }
    }
}
