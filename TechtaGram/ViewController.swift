//
//  ViewController.swift
//  TechtaGram
//
//  Created by 伊藤愛結 on 2021/02/06.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cameraImageView: UIImageView!
    
    var originalImage: UIImage!
    var filter: CIFilter!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func takePhoto(){
        
        //カメラを使えるか
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }else{
            print("error")
        }
        
    }
    
    //カメラ、カメラロールを使ったときに選択した画像をアプリ内で表示させるためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraImageView.image = info[.editedImage] as? UIImage
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePhoto(){
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image! , nil, nil, nil)
    }
    
    @IBAction func colorFilter(){
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の設定
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラスト
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    
    @IBAction func openAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker,animated: true, completion: nil)
        }
    }
    
    @IBAction func snsPhoto(){
        //投稿するときに一緒に載せるコメント
        let shareText = "写真加工いえい"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //コメントと画像の準備
        let activityItems: [Any] = [shareText,shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems,applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
    }


}

