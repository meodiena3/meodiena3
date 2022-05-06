import Scenes
import Igis

class InteractionLayer : Layer, KeyDownHandler
{
    let paddleLeft = Paddle(rect:Rect(size:Size(width:10, height:100)))
    let paddleRight = Paddle(rect:Rect(size:Size(width:10, height:100)))

    init()
    {
        super.init(name:"Interaction")

        insert(entity: paddleLeft, at: .front)
        insert(entity: paddleRight, at: .front)
    }

    override func preSetup(canvasSize: Size, canvas: Canvas)
    {
        paddleLeft.move(to:Point(x: 100, y: 480))
        paddleRight.move(to:Point(x: 1850, y: canvasSize.center.y))

        dispatcher.registerKeyDownHandler(handler: self)

    }

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool)
    {
        let tlpl = paddleLeft.rectangle.rect.topLeft
        let tlpr = paddleRight.rectangle.rect.topLeft
        switch key
        {
        case "w":
            paddleLeft.move(to:Point(x: tlpl.x, y:tlpl.y - 10))
        case "s":
            paddleLeft.move(to:Point(x: tlpl.x, y:tlpl.y + 10))
        case "ArrowUp":
            paddleRight.move(to:Point(x: tlpr.x, y:tlpr.y - 10))
        case "ArrowDown":
            paddleRight.move(to:Point(x: tlpr.x, y:tlpr.y + 10))
        default:
            break
        }

    }

    override func postTeardown()
    {
        dispatcher.unregisterKeyDownHandler(handler: self)
    }
}
