import UIKit
import SnapKit

let incomingTag = 0, outgoingTag = 1
let bubbleTag = 8

class MessageBubbleTableViewCell:UITableViewCell{
    let bubbleImageView: UIImageView
    let messageLabel: UILabel
    let portraitImgView: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        portraitImgView = UIImageView.init(image: UIImage.init(named: "img_placeholder"))
        portraitImgView.isUserInteractionEnabled = false
        
        bubbleImageView = UIImageView(image: bubbleImage.incoming, highlightedImage: bubbleImage.incomingHighlighed)
        bubbleImageView.tag = bubbleTag
        bubbleImageView.isUserInteractionEnabled = false // #CopyMesage
        
        messageLabel = UILabel(frame: CGRect.init(x: 0, y: 0, w: 0, h: 0))
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.numberOfLines = 0
        messageLabel.isUserInteractionEnabled = false   // #CopyMessage
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(portraitImgView)
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        portraitImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(4.5)
        }
        
        bubbleImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35 + 10 + 4)
            make.top.equalToSuperview().offset(4.5)
            make.width.equalTo(messageLabel.snp.width).offset(30)
            make.bottom.equalToSuperview().offset(-4.5)
        }
        messageLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(bubbleImageView.snp.centerX).offset(3)
            make.centerY.equalTo(bubbleImageView.snp.centerY).offset(-0.5)
            messageLabel.preferredMaxLayoutWidth = 230
            make.height.equalTo(bubbleImageView.snp.height).offset(-15)
            
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithMessage(message: Message) {
        messageLabel.text = message.text
        if message.incoming {
            portraitImgView.image = UIImage.init(named: "employee_portrait")
            portraitImgView.snp.remakeConstraints({ (make) in
                make.width.height.equalTo(35)
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(4.5)
            })
        }
        else{
            portraitImgView.image = UIImage.init(named: "customer_portrait")
            portraitImgView.snp.remakeConstraints({ (make) in
                make.width.height.equalTo(35)
                make.right.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(4.5)
            })
        }
        
        let constraints: NSArray = contentView.constraints as NSArray
        let indexOfConstraint = constraints.indexOfObject { ( constraint, idx, stop) in
            return ((constraint as AnyObject).firstItem as! UIView).tag == bubbleTag && ((constraint as AnyObject).firstAttribute == NSLayoutAttribute.left || (constraint as AnyObject).firstAttribute == NSLayoutAttribute.right)
        }
        contentView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
        bubbleImageView.snp.makeConstraints({ (make) -> Void in
            if message.incoming {
                tag = incomingTag
                bubbleImageView.image = bubbleImage.incoming
                bubbleImageView.highlightedImage = bubbleImage.incomingHighlighed
                messageLabel.textColor = RGBA(r: 52, g: 52, b: 52, a: 1)
                make.left.equalToSuperview().offset(10 + 35 + 4)
                messageLabel.snp.updateConstraints { (make) -> Void in
                    make.centerX.equalTo(bubbleImageView.snp.centerX).offset(3)
                }
                
            } else { // outgoing
                tag = outgoingTag
                bubbleImageView.image = bubbleImage.outgoing
                bubbleImageView.highlightedImage = bubbleImage.outgoingHighlighed
                messageLabel.textColor = UIColor.white
                make.right.equalToSuperview().offset(-10 - 35 - 4)
                messageLabel.snp.updateConstraints { (make) -> Void in
                    make.centerX.equalTo(bubbleImageView.snp.centerX).offset(-3)
                }
            }
        })
    }
    
    // 设置cell高亮
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        bubbleImageView.isHighlighted = selected
    }
}

let bubbleImage = bubbleImageMake()

func bubbleImageMake() -> (incoming: UIImage, incomingHighlighed: UIImage, outgoing: UIImage, outgoingHighlighed: UIImage) {
    let maskIncoming = UIImage(named: "rep_white_message_bubble")!
    let maskOutgoing = UIImage(named: "rep_message_bubble")!
    
    let capInsetsIncoming = UIEdgeInsets(top: 25, left: 40, bottom: 10, right: 21)
    let capInsetsOutgoing = UIEdgeInsets(top: 25, left: 21, bottom: 10, right: 40)
    
    let incoming = maskIncoming.resizableImage(withCapInsets: capInsetsIncoming)
    let outgoing = maskOutgoing.resizableImage(withCapInsets: capInsetsOutgoing)
    
    return (incoming, incoming, outgoing, outgoing)
}

