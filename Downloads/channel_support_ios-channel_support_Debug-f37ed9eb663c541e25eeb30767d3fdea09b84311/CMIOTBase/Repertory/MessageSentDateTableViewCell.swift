import UIKit
import SnapKit
class MessageSentDateTableViewCell: UITableViewCell {
    let sentDateLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        sentDateLabel = UILabel(frame: CGRect.init(x: 0, y: 0, w: 0, h: 0))
        sentDateLabel.backgroundColor = UIColor.clear
        sentDateLabel.font = UIFont.systemFont(ofSize: 10)
        sentDateLabel.textAlignment = .center
        sentDateLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(sentDateLabel)
        
        // Flexible width autoresizing causes text to jump because center text alignment doesn't animate
        sentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        sentDateLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(13)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4.5)
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
