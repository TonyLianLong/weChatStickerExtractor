//
//  ViewController.swift
//  weChatStickerExtractor
//
//  Created by tll on 13/06/2017.
//  Copyright © 2017 tll. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    func extract(){
        let manager = FileManager.default;
        let contentsOfURL = try? manager.contentsOfDirectory(at: URL(fileURLWithPath:"/Users/tll/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9"), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles);
        //print("contentsOfURL: \(contentsOfURL)")
        var numCount = 1;
        for item in contentsOfURL!{
            let pathArray = item.pathComponents;
            let subName = pathArray[pathArray.count-1];
            let len = subName.lengthOfBytes(using: String.Encoding.ascii);
            if(len == 32){
                print(subName);
                let stickerPath = "/Users/tll/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/\(subName)/Stickers/File";
                if(!manager.fileExists(atPath: stickerPath)){
                    continue;
                }
                let contentsOfStickerPath = try? manager.contentsOfDirectory(at: URL(fileURLWithPath:stickerPath), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles);
                print("contentsOfStickerPath: \(contentsOfStickerPath)")
                
                let stickerDestDirectory:String = NSHomeDirectory() + "/Desktop/Stickers/\(numCount)";
                try! manager.createDirectory(atPath: stickerDestDirectory,withIntermediateDirectories: true, attributes: nil);
                var stickerCount = 1;
                for stickerContent in contentsOfStickerPath!{
                    print(stickerContent)
                    let attr = try! manager.attributesOfItem(atPath: stickerContent.path);
                    let creationDate = attr[FileAttributeKey.creationDate]
                    try! manager.copyItem(at: stickerContent, to: URL(fileURLWithPath:stickerDestDirectory + "/\(stickerCount)-\(creationDate!).gif"));
                    stickerCount += 1;
                }
                numCount += 1;
            }
        }
    }
    func msgbox(){
        let alert = NSAlert();
        alert.messageText = "完成";
        alert.informativeText = "表情包提取到桌面上的Stickers目录里啦，点进去看看吧。";
        alert.beginSheetModal( for: view.window! )
        { returnCode in
            
            if ( returnCode == NSAlertSecondButtonReturn ){
                print("Msgbox Finished");
            }
        }
    }
    @IBAction func extractBtn(_ sender: Any) {
        extract();
        msgbox();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

