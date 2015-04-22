//////////////////////////////////////////////////////////////////////////////
//  Project:    Morpho X                                                    //
//  Filename:   Xchart.qml                                                  //
//  Date:       2015.01.04                                                  //
//////////////////////////////////////////////////////////////////////////////
//  Description:    New Xchart docs                                         //
//  Todo:   improve cpu utilization(worker script)                          //
//////////////////////////////////////////////////////////////////////////////

import QtQuick 2.0

Item{
    id:chart    ;

    //  define options used for the default settings of Xchart
    property var options: {"color":"#ffffff","xmax":1200,"xmin":200,"ymax":65535,"ymin":0,
                           "default":{"xmin":200,"xmax":1200,"ymin":0,"ymax":65535},
                           "axisStyle":{"axisMargin":10,"color":"black","gridColor":"#d7d7d7"},
                           "xlabel":"Wavelength(nm)","ylabel":"Counts(u,v)"} ;

    //  define plot used for canvas named plot
    property alias plot: plot   ;
    property alias line: plot.line ;
    //  define line put the line need to plot

    signal renew()  ;
    //  signal renew will replot the Chart(figur,axis && plot)


    Canvas{
        id:figure   ;
        // canvas figurs is only used for paint xaxis & yaxis lines and texts
        // leave 15 pixels in left and bottom for xlabel & ylabel
        anchors.fill: parent    ;
        //anchors.margins:options.axisStyle.axisMargin    ;
        anchors.leftMargin: options.axisStyle.axisMargin  ;
        anchors.bottomMargin: options.axisStyle.axisMargin-15  ;
        // leave 15 pixels for xlabel & ylabel
        //////////////////////////////////////////
        //  x ^             //                  //
        //  a |             //  Figure is the   //
        //  x |  figure     //  background of   //
        //  i |             //  the axis and    //
        //  s |_ _ _ _ _ >  //  axis-lines .    //
        //        yaxis     //                  //
        //////////////////////////////////////////

        onPaint:{
            var xnum=10 ;
            var ynum=20 ;
            var axisspace=50    ;
            // Create 25 xaxises and 25 yaxises
            // Define axisspace for the width of axis' text

            var ctx=getContext("2d")    ;
            ctx.clearRect(0,0,width,height) ;
            // Clear the area

            /////////////////////////////////////////////////////
            //                  Plot X-Axis                    //
            /////////////////////////////////////////////////////

            ctx.strokeStyle=options.axisStyle.color    ;
            ctx.beginPath() ;
            ctx.moveTo(axisspace,height-axisspace)  ;
            ctx.lineTo(width-axisspace,height-axisspace)    ;
            ctx.stroke()    ;
            //  Plot x-axis
            ctx.strokeStyle=options.axisStyle.color    ;
            ctx.beginPath() ;
            ctx.moveTo(axisspace,height-axisspace)  ;
            ctx.lineTo(axisspace,axisspace) ;
            ctx.stroke()    ;
            //  Plot y-axis

            var xspace = Math.floor((options.xmax-options.xmin)/Math.pow(10,Math.floor(Math.log(options.xmax-options.xmin)*Math.LOG10E)))
                    *Math.pow(10,Math.floor(Math.log(options.xmax-options.xmin)*Math.LOG10E))/xnum*2    ;
            xnum=Math.floor((options.xmax-options.xmin)/xspace) ;
            // xspace is the length of every single xaxis
            // xnum is the number of xaxis

            var xlength=xspace/(options.xmax-options.xmin)*(width-2*axisspace)  ;
            // xlength is the length of xaxis

            for (var i=0;i<xnum+1;++i)
            {
                ctx.strokeStyle=options.axisStyle.color ;
                //  set xaxis color

                ctx.beginPath() ;
                ctx.moveTo(axisspace+i*xlength,height-axisspace)    ;
                //  first points

                ctx.lineTo(axisspace+i*xlength,height-axisspace-3)  ;
                //  height of xaxis_line is 3 pixels

                ctx.stroke()    ;
                //  plot lines

                ctx.textAlign="center"  ;
                ctx.textBaseline="top"  ;

                //  text style
                ctx.font= "12px sans-serif" ;
                ctx.fillText(Math.floor((options.xmin+xspace*i)*1000)/1000,axisspace+i*xlength,height-axisspace)    ;
                ctx.restore()   ;

                //  add texts
                ctx.beginPath()
                ctx.strokeStyle = options.axisStyle.gridColor ;
                ctx.moveTo(axisspace+i*xlength,height-axisspace-3)  ;
                ctx.lineTo(axisspace+i*xlength,axisspace)   ;
                ctx.stroke()    ;
                ctx.restore()   ;
                //  add xGrid
            }

            /////////////////////////////////////////////////////
            //                  Plot Y-Axis                    //
            /////////////////////////////////////////////////////

            var yspace=Math.pow(10,Math.floor(Math.log(options.ymax-options.ymin)*Math.LOG10E))/2   ;
            ynum=Math.floor((options.ymax-options.ymin)/yspace) ;
            // yspace is the length of every single yaxis
            // ynum is the number of yaxis

            var ylength=yspace/(options.ymax-options.ymin)*(height-2*axisspace) ;
            // ylength is the length of yaxis

            for(var j=0;j<ynum+1;++j)
            {
                ctx.strokeStyle=options.axisStyle.color    ;

                //  set yaxis color
                ctx.beginPath() ;
                ctx.moveTo(axisspace,height-axisspace-j*ylength)    ;
                ctx.lineTo(axisspace+3,height-axisspace-j*ylength)    ;

                //  height of yaxis
                ctx.stroke()    ;

                ctx.font= "12px sans-serif" ;
                ctx.textAlign="right"   ;
                ctx.textBaseline="middle"   ;
                ctx.fillText(Math.floor((options.ymin+yspace*j)*10)/10,axisspace-3,height-axisspace-j*ylength)  ;

                //  add text
                ctx.restore()   ;
                ctx.beginPath() ;
                ctx.strokeStyle = options.axisStyle.gridColor;
                ctx.moveTo(axisspace+3,height-axisspace-j*ylength)  ;
                ctx.lineTo(width-axisspace,height-axisspace-j*ylength)  ;
                ctx.stroke()    ;
                ctx.restore()   ;
            }

        }
    }

    Item{
        // leftarea used for ylabel
        id:leftarea ;
        anchors.left:parent.left    ;
        anchors.right:figure.left ;
        anchors.rightMargin: 15 ;
        anchors.top:parent.top  ;
        anchors.bottom:parent.bottom    ;

        Text{
            //  ylabel
            id:ylabel   ;
            anchors.centerIn: leftarea  ;
            text:options.ylabel  ;
            font.family: "Verdana"  ;
            font.pointSize: 12  ;
            rotation: 270   ;
        }
    }
    //  ytitle

    Item{
        id:bottomarea   ;

        //  bottomarea used for xlabel
        anchors.top:figure.bottom ;
        anchors.topMargin: -20  ;
        anchors.bottom:parent.bottom    ;
        anchors.left:parent.left    ;
        anchors.right:parent.right  ;
        width:parent.width  ;

        Text{
            //  xlabel
            id:xlabel   ;
            text:options.xlabel   ;
            font.family: "Verdana"  ;
            font.pointSize: 12  ;
            anchors.top:bottomarea.top  ;
            anchors.horizontalCenter: bottomarea.horizontalCenter   ;
        }
    }
    //  xtitle

    Item{
        id:toparea  ;
        anchors.top:parent.top  ;
        anchors.topMargin:20    ;
        width:parent.width  ;
        Text{
            id:title    ;
            anchors.centerIn:parent ;
            font.family: "Verdana"  ;
            font.pointSize: 12  ;
        }
    }
    //  Title

    Canvas{
        id:plot ;
        renderStrategy:Canvas.Cooperative  ;
        renderTarget :Canvas.FramebufferObject  ;
        anchors.fill:figure ;
        anchors.margins: 50 ;
        //  canvas plot is used for plot lines

        property var line:[{x:[0],y:[0],linewidth:1,color:"blue",selected:false,viewAllow:true,dragAllow:false,}]
        //  line is the data & style of lines

        property bool dragModel:false ;
        property var dragLine   ;

        function plotline(line){
            var i   ;
            var j   ;
            getContext("2d").clearRect(0,0,width,height)    ;
            for (j=0;j<line.length;j++)
            {
                //  find all lines
                if(line[j].viewAllow)
                    // if the line is viewAllow
                {
                    getContext("2d").strokeStyle=line[j].color ;
                    getContext("2d").lineWidth=line[j].lineWidth   ;

                    //  move to first point
                    getContext("2d").beginPath()    ;
                    getContext("2d").moveTo((line[j].x[0]-options.xmin)/(options.xmax-options.xmin)*(width),
                                            (options.ymax-line[j].y[0])/(options.ymax-options.ymin)*(height));

                    //  plot lines
                    for (i=1;i<line[j].x.length;++i)
                    {
                        getContext("2d").lineTo((line[j].x[i]-options.xmin)/(options.xmax-options.xmin)*(width),
                                                (options.ymax-line[j].y[i])/(options.ymax-options.ymin)*(height));
                    }
                    getContext("2d").stroke()   ;
                    getContext("2d").restore()  ;
                }
            }
                i=null  ;
                j=null  ;
        }

        onPaint:{
            //  judge if dragcanvas is in drag mode
            if(!dragcanvas.choose)
            {
                plotline(line) ;
            }
        }
    }
    //  plot

    Canvas{
        id:dragcanvas  ;

        renderStrategy:Canvas.Cooperative  ;
        renderTarget :Canvas.FramebufferObject  ;
        anchors.fill:dragarea  ;
        property real lastX ;
        property real lastY ;
        property bool choose    ;
        //定义坐标
        //定义布朗值：用于选择画图动作

        onPaint:{
            var ctx=getContext("2d")    ;
            if (choose){
                ctx.clearRect(0,0,width,height)
                ctx.strokeStyle="grey"
                ctx.lineWidth = 1
                ctx.strokeRect(dragarea.xminmum,dragarea.yminmum,lastX-dragarea.xminmum,lastY-dragarea.yminmum)
                ctx.stroke()
            }
            else{
                ctx.clearRect(0,0,width,height)
            }

        }
    }
    //创建一个canvas用于画拖拽的框架

    MouseArea{
        id: dragarea   ;
        anchors.fill:plot   ;

        property real xminmum   ;
        property real xmaxmum   ;
        property real yminmum   ;
        property real ymaxmum   ;

        //localtion
        onPressed:{
            xminmum=mouseX  ;
            yminmum=mouseY  ;
            for(var j=0;j<line.length;++j)
                //  find all lines
            {
                if(line[j].dragAllow)
                    //  check the line is dragAllow
                {
                    for(var i=0;i<line[j].x.length;++i)
                        //  check mouse moved
                    {
                        if(line[j].x[i]<(mouseX*(options.xmax-options.xmin)/dragarea.width+options.xmin)+
                                (options.xmax-options.xmin)*0.01&
                           line[j].x[i]>(mouseX*(options.xmax-options.xmin)/dragarea.width+options.xmin)-
                                (options.xmax-options.xmin)*0.01)
                        {
                            plot.dragModel=true ;
                            plot.dragLine=j ;
                            break;
                        }
                    }
                }
            }

            //menu.close()
            //  check menu status
        }        

        onReleased:{
            //  close dragcanvas' dragmode
            dragcanvas.choose=0
            xmaxmum=mouseX
            ymaxmum=mouseY
            if(plot.dragModel){
                plot.dragModel=false    ;
            }
            else{
                // resize()
                resize(xminmum,yminmum,xmaxmum,ymaxmum)
                dragcanvas.requestPaint()
            }

        }

        onPositionChanged: {
            //  judge if plot's line is in drag mode
            if (plot.dragModel){
                for (var i=0;i<line[plot.dragLine].x.length;++i)
                {
                    //  if true change line's x location
                    line[plot.dragLine].x[i]=(mouseX)*(options.xmax-options.xmin)/dragarea.width+options.xmin    ;
                }
                plot.requestPaint()
            }
            else{
                // if false : dragcanvas change to drag mode
                dragcanvas.choose=1
                if (mouseX<=0 | mouseY<=0)
                {
                    //  if mouse move to leftdown
                    dragcanvas.choose=0
                }
                else if(mouseX>width | mouseY>height){
                    //  if mouse move to rightup
                    dragcanvas.choose=0
                }

                dragcanvas.lastX = mouseX
                dragcanvas.lastY = mouseY
                //  get recent mouse location
                //  and requestPaint()
                dragcanvas.requestPaint()
            }
        }

        //  function resize will change the figure's xmin/xmin ymax/ymin
        //  and recalculate lines' location in plot
        function resize(xminmum,yminmum,xmaxmum,ymaxmum){
            var xmintemp
            var xmaxtemp
            var ymintemp
            var ymaxtemp
            if (xmaxmum>=width)
            {
                xmaxmum=width
            }
            if (ymaxmum>=height)
            {
                ymaxmum=height
            }

            //  calculate the max/min and ymax/ymin
            //  recalculate the locations of points
            if (xminmum<xmaxmum & yminmum<ymaxmum)
            {
                xmintemp=xminmum*(options.xmax-options.xmin)/dragarea.width+options.xmin
                xmaxtemp=xmaxmum*(options.xmax-options.xmin)/dragarea.width+options.xmin
                ymaxtemp=(dragarea.height-yminmum)*(options.ymax-options.ymin)/dragarea.height+options.ymin
                ymintemp=(dragarea.height-ymaxmum)*(options.ymax-options.ymin)/dragarea.height+options.ymin

                options.xmin=xmintemp
                options.xmax=xmaxtemp
                options.ymin=ymintemp
                options.ymax=ymaxtemp
                plot.requestPaint()
                figure.requestPaint()
            }
            //  else rechange to default size
            else if(xminmum>xmaxmum & yminmum>ymaxmum){
                options.xmin=options.default.xmin
                options.xmax=options.default.xmax
                options.ymin=options.default.ymin
                options.ymax=options.default.ymax
                plot.requestPaint()
                figure.requestPaint()
            }
        }

    }

    //  signal renew() will replot the canvas
    onRenew: {
        dragcanvas.requestPaint()   ;
        plot.requestPaint() ;
        figure.requestPaint()   ;
    }

}
