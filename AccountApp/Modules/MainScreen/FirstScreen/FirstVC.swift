import CoreData
import Photos
import PhotosUI
import UIKit

class FirstViewController: UIViewController {
    
    private let sessionManager = SessionManager()
    private let formatter = DateFormatter()
    private weak var timer: Timer?
    private var photos = [UIImage]()
    private var videos = [URL]()
    private let animations = ["christmasAnimation", "bicycleAnimation", "limonAnimation", "pumpkinAnimation", "rocketAnimation"]
    private var isVideo = true
    private var isVideoFromLive = false
    private var messageForAlert: String?
    private var doneText: String?
    private var cancelText: String?
    private var saveText: String?
    
    // MARK: - IBOutlets
    
 //   @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    // MARK: - IBActions
    
    @IBAction private func switchSegmentControl(_ sender: Any) {
        if isVideo {
            isVideo = false
            collectionView.reloadData()
        } else {
            isVideo = true
            collectionView.reloadData()
        }
    }
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStrings()
        handleLanguage()
        setupFormatter()
        registreCell()
        setupCollection()
        setupNavigationButton()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerHandler(_:)), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        collectionView.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    // MARK: - Setup
    
    private func setupFormatter() {
        formatter.dateFormat = "K:mm:ss"
    }
    
    private func setupTime() {
 //       timerLabel.text = formatter.string(from: (sessionManager.defaults.object(forKey: "timer") as! Date))
    }
    
    private func setupNavigationButton() {
        let addButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(addVideo))
        addButton.image = UIImage(named: "iconPlus")
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func registreCell() {
        collectionView.register(CustomViewForVideoCell.self, forCellWithReuseIdentifier: CustomViewForVideoCell.identifier)
        collectionView.register(CustomViewForAnimationCell.self, forCellWithReuseIdentifier:
            CustomViewForAnimationCell.identifier)
    }
    
    private func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.size.width, height: 300)
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    
    private func setupStrings() {
        navigationController?.navigationBar.topItem?.title = L10n.empty
        segmentControl.setTitle(L10n.firstVCSegmentControlFirst, forSegmentAt: 0)
        segmentControl.setTitle(L10n.firstVCSegmentControlSecond, forSegmentAt: 1)
        messageForAlert = L10n.alertSaveVideoMessage
        doneText = L10n.alertDoneTitle
        cancelText = L10n.cancel
        saveText = L10n.save
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
    
    @objc func addVideo() {
        showImagePickerActionSheet()
    }
    
    @objc func timerHandler(_ timer: Timer) {
        guard let time = (sessionManager.defaults.object(forKey: "timer") as? Date)?.addingTimeInterval(1.0) else { return }
        sessionManager.defaults.set(time, forKey: "timer")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.reloadData()
    }

}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isVideo ? videos.count : animations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isVideo {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomViewForVideoCell.identifier, for: indexPath) as! CustomViewForVideoCell
            cell.configure(with: videos[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomViewForAnimationCell.identifier, for: indexPath) as! CustomViewForAnimationCell
            cell.configure(with: animations[indexPath.row])
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isVideo {
            let storyboard = UIStoryboard(name: "VideoScreen", bundle: nil)
            guard let vc = storyboard.instantiateViewController(identifier: "VideoViewController") as? VideoViewController else { return }
            let backButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(backAction))
            backButton.image = UIImage(named: "iconBack")
            vc.navigationItem.leftBarButtonItem = backButton
            vc.configure(with: videos[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func backAction() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension FirstViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func showImagePickerActionSheet() {
        let photoLibraryAction = UIAlertAction(title: "Choose video from Library", style: .default) { _ in
            self.showImagePicker(sourceType: .savedPhotosAlbum)
        }
        let cameraAction = UIAlertAction(title: "Make video", style: .default) { _ in
            self.showImagePicker(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Choose your image", message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .camera {
            isVideoFromLive = true
        } else {
            isVideoFromLive = false
        }
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        imagePickerVC.sourceType = sourceType
        imagePickerVC.mediaTypes = ["public.movie"]
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        videos.append(videoURL)
        let videoData = NSData(contentsOf: videoURL)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let dataPath = paths.appending("/videoFileName.mp4")
        videoData?.write(toFile: dataPath, atomically: false)
        collectionView.reloadData()
        let yesAction = UIAlertAction(title: doneText, style: .default, handler: { _ in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: dataPath))
            }) { saved, _ in
                if saved {
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                    _ = PHAsset.fetchAssets(with: .video, options: fetchOptions).firstObject
                }
            }
        })
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        dismiss(animated: true, completion: {
            if self.isVideoFromLive {
                AlertService.showAlert(style: .alert, title: self.saveText, message: self.messageForAlert, actions: [yesAction, cancelAction], completion: nil)
            }
        })
    }
}
