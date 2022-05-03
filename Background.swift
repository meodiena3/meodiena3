import Foundation
import Scenes
import Igis

class Background: RenderableEntity, MouseMoveHandler
{
    let ellipse = Ellipse(center:Point(x:0, y:0), radiusX:30, radiusY:30, fillMode:.fillAndStroke)
    let strokeStyle = StrokeStyle(color:Color(.orange))
    let fillStyle = FillStyle(color:Color(.red))
    let lineWidth = LineWidth(width:5)
    var didRender = false
    var gridRectangles : [Rectangle] = [Rectangle]();
    var gridRectangles1 : [Rectangle] = [Rectangle]();
    var gridRectangles2 : [Rectangle] = [Rectangle]();
    var gridRectangles3 : [Rectangle] = [Rectangle]();
    var gridRectangles4 : [Rectangle] = [Rectangle]();
    let mm: Image

    var velocityX : Int
    var velocityY : Int

    init()
    {
        velocityX = 0
        velocityY = 0
        guard let mmURL = URL(string:"https://upload.wikimedia.org/wikipedia/commons/f/f1/Triangle_warning_sign_%28red_and_yellow%29.svg")
        else
        {
            fatalError("Failed to create URL for symbol")
        }
        mm = Image(sourceURL:mmURL)
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Ball")
    }

    func makeRect(x:Int, y:Int, width:Int, height:Int) -> Rectangle
    {
        let rect = Rect(topLeft:Point(x:x, y:y), size:Size(width:width, height:height))
        return Rectangle(rect:rect, fillMode:.fillAndStroke)
    }

    func sky(canvas:Canvas)
    {
        let l = LineWidth(width:5)
        let sf = FillStyle(color:Color(.blue))
        let ss = StrokeStyle(color:Color(.blue))
        gridRectangles.append(makeRect(x:0, y:0, width:2000, height:500))

        for rec in gridRectangles
        {
            canvas.render(sf, ss, rec, l)
        }
    }

    func grass(canvas:Canvas)
    {
        let l1 = LineWidth(width:5)
        let gf = FillStyle(color:Color(.green))
        let gs = StrokeStyle(color:Color(.green))
        gridRectangles1.append(makeRect(x:0, y:500, width:2000, height:500))

        for rec1 in gridRectangles1
        {
            canvas.render(gf, gs, rec1, l1)
        }
    }

    func whatsthename(canvas:Canvas)
    {
        let l2 = LineWidth(width:10)
        let wf = FillStyle(color:Color(.yellow))
        let ws = StrokeStyle(color:Color(.red))
        gridRectangles2.append(makeRect(x:125, y:475, width:300, height:50))

        for rec2 in gridRectangles2
        {
            canvas.render(wf, ws, rec2, l2)
        }
    }

    func balloon(canvas:Canvas)
    {
        let l3 = LineWidth(width:5)
        let bf = FillStyle(color:Color(.red))
        let bs = StrokeStyle(color:Color(.white))
        gridRectangles3.append(makeRect(x:1170, y:300, width:10, height:200))

        for rec3 in gridRectangles3
        {
            canvas.render(bf, bs, rec3, l3)
        }
    }

    func table(canvas:Canvas)
    {
        let l4 = LineWidth(width:5)
        let tf = FillStyle(color:Color(.yellow))
        let ts = StrokeStyle(color:Color(.purple))
        gridRectangles4.append(makeRect(x:670, y:510, width:400, height:75))
        gridRectangles4.append(makeRect(x:695, y:580, width:50, height:75))
        gridRectangles4.append(makeRect(x:995, y:580, width:50, height:75))

        for rec4 in gridRectangles4
        {
            canvas.render(tf, ts, rec4, l4)
        }
    }

    override func setup(canvasSize: Size, canvas: Canvas)
    {
        // Position the ellipse at the center of the canvas
        ellipse.center = canvasSize.center

        dispatcher.registerMouseMoveHandler(handler:self)

        canvas.setup(mm)
    }

    override func teardown()
    {
        dispatcher.unregisterMouseMoveHandler(handler:self)
    }

    func onMouseMove(globalLocation: Point, movement: Point)
    {
        ellipse.center = globalLocation
        didRender = false
    }

    override func boundingRect() -> Rect
    {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }

    override func render(canvas:Canvas)
    {
        if let canvasSize = canvas.canvasSize,  didRender == false
        {
            // Clear the entire canvas
            let clearRect = Rect(topLeft:Point(x:0, y:0), size:canvasSize)
            let clearRectangle = Rectangle(rect:clearRect, fillMode:.clear)
            canvas.render(clearRectangle)

            sky(canvas:canvas)
            grass(canvas:canvas)
            whatsthename(canvas:canvas)
            let oo = Ellipse(center:Point(x:1175, y:250), radiusX:50, radiusY:50, fillMode:.fillAndStroke)
            let oos = StrokeStyle(color:Color(.white))
            let oof = FillStyle(color:Color(.red))
            canvas.render(oos, oof, oo)
            balloon(canvas:canvas)
            table(canvas:canvas)

            if mm.isReady
            {
                mm.renderMode = .destinationRect(Rect(topLeft:Point(x:200, y:525), size:Size(width:150, height:100)))
            }
            canvas.render(mm)

            canvas.render(strokeStyle, fillStyle, lineWidth, ellipse)
        }
        didRender = true
    }
}
