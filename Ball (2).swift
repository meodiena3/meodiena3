import Foundation
import Scenes
import Igis

class Ball: RenderableEntity, MouseMoveHandler
{
    var ellipse = Ellipse(center:Point(x:0, y:0), radiusX:51, radiusY:51, fillMode:.fillAndStroke)
    let strokeStyle = StrokeStyle(color:Color(.orange))
    let fillStyle = FillStyle(color:Color(.red))
    let lineWidth = LineWidth(width:5)
    var didRender = false

    var velocityX : Int
    var velocityY : Int
    var defaultVelocityX: Int
    var defaultVelocityY: Int
    var doubleVelocityX: Double
    var doubleVelocityY: Double
    var defaultRadiusX = 51
    var defaultRadiusY = 51

    init()
    {
        self.velocityX = 3
        self.velocityY = 3
        self.defaultVelocityX = 5
        self.defaultVelocityY = 5
        self.doubleVelocityX = 0
        self.doubleVelocityY = 0

        // Using a meaningful name can be helpful for debugging
        super.init(name:"Ball")
    }

    func changeVelocity(velocityX:Int, velocityY:Int)
    {
        self.velocityX = velocityX
        self.velocityY = velocityY
        self.defaultVelocityX = 3
        self.defaultVelocityY = 3
        self.doubleVelocityX = Double(velocityX)
        self.doubleVelocityY = Double(velocityY)
    }
    override func calculate(canvasSize: Size)
    {
        // First, move to the new position
        ellipse.center += Point(x:velocityX, y:velocityY)

        // Form a bounding rectangle around the canvas
        let canvasBoundingRect = Rect(size:canvasSize)

        // Form a bounding rect around the ball (ellipse)
        let ballBoundingRect = Rect(topLeft:Point(x:ellipse.center.x-ellipse.radiusX, y:ellipse.center.y-ellipse.radiusY), size:Size(width:ellipse.radiusX*2, height:ellipse.radiusY*2))

        // Determine if we've moved outside of the canvas boundary rect
        let tooFarLeft = ballBoundingRect.topLeft.x <= canvasBoundingRect.topLeft.x
        let tooFarRight = ballBoundingRect.topLeft.x + ballBoundingRect.size.width >= canvasBoundingRect.topLeft.x + canvasBoundingRect.size.width

        let tooFarUp = ballBoundingRect.topLeft.y <= canvasBoundingRect.topLeft.y
        let tooFarDown = ballBoundingRect.bottomLeft.y + ballBoundingRect.size.height >= canvasBoundingRect.topLeft.y + canvasBoundingRect.size.height

        if tooFarLeft || tooFarRight{
            velocityX *= -4
            //taking a property of the ellipse object, radiusX, and we're changing it
            ellipse.radiusX = ellipse.radiusX/2
        }
        if tooFarUp || tooFarDown{
            velocityY *= -4
            ellipse.radiusY = ellipse.radiusY/2
        }
        func slowDown(velocity: inout Int, defaultVelocity: Int, doubleVelocity: inout Double){
            doubleVelocity = Double(velocity)
            if abs(velocity) > defaultVelocity{
                var change = -0.1
                if doubleVelocity.sign == .minus{
                    change = 0.1
                }
                doubleVelocity += change
                velocity = Int(doubleVelocity)
            }
            else if abs(velocity) < defaultVelocity{
                //doubleVelocity = Double(defaultVelocity)
                velocity = defaultVelocity
            }
        }

        func growRadius(radius: inout Int, defaultRadius: Int){
            if radius < defaultRadius{
                var change = 2
                if Double(radius).sign == .minus{
                    change = -2
                }
                radius += change
            }
            else if abs(radius) > defaultRadius{
                radius = defaultRadius
            }
        }
        slowDown(velocity: &velocityX, defaultVelocity:defaultVelocityX, doubleVelocity: &doubleVelocityX)
        slowDown(velocity: &velocityY, defaultVelocity:defaultVelocityY, doubleVelocity: &doubleVelocityY)
        growRadius(radius: &ellipse.radiusX, defaultRadius:defaultRadiusX)
        growRadius(radius: &ellipse.radiusY, defaultRadius:defaultRadiusY)
    }
    override func setup(canvasSize: Size, canvas: Canvas)
    {
        // Position the ellipse at the center of the canvas
        ellipse.center = canvasSize.center

        dispatcher.registerMouseMoveHandler(handler:self)
    }

    override func teardown()
    {
        dispatcher.unregisterMouseMoveHandler(handler:self)
    }

    func onMouseMove(globalLocation: Point, movement: Point)
    {
        changeVelocity(velocityX:velocityX, velocityY:velocityY)
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

            canvas.render(strokeStyle, fillStyle, lineWidth, ellipse)
        }
        didRender = true
    }
}
