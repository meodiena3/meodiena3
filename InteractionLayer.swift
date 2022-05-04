import Scenes

/*
 This class is responsible for the interaction Layer.
 Internally, it maintains the RenderableEntities for this layer.
 */


class InteractionLayer : Layer
{
//    let ball = Ball()
    let background = Background()

    init()
    {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")

        // We insert our RenderableEntities in the constructor
        insert(entity: background, at:.back)
        //          insert(entity: ball, at: .front)
        //          ball.changeVelocity(velocityX: 6, velocityY: 6)
    }
}
   
