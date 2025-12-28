//
//  CameraPickerView.swift
//  CalSnap
//
//  Full-screen camera interface for capturing meal photos
//

import SwiftUI
import PhotosUI
import AVFoundation

struct CameraPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CameraPickerViewModel()
    
    var onImagesSelected: ([UIImage]) -> Void
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreviewView(session: viewModel.captureSession)
                .ignoresSafeArea()
            
            VStack {
                // Top Bar with Action Buttons
                HStack(spacing: 12) {
                    // Close Button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Add Button (green)
                    if !viewModel.selectedImages.isEmpty {
                        Button {
                            onImagesSelected(viewModel.selectedImages)
                            dismiss()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Add")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.green)
                            .cornerRadius(22)
                        }
                    }
                    
                    // Analyze Button (white)
                    if !viewModel.selectedImages.isEmpty {
                        Button {
                            // Analyze action
                            viewModel.analyzeImages()
                        } label: {
                            Text("Analyze")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(22)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                Spacer()
                
                // Thumbnail Strip
                if !viewModel.selectedImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(viewModel.selectedImages.enumerated()), id: \.offset) { index, image in
                                ThumbnailView(image: image) {
                                    viewModel.removeImage(at: index)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 100)
                }
                
                // Bottom Controls
                HStack(spacing: 40) {
                    // Photo Library Button
                    Button {
                        viewModel.showPhotoLibrary = true
                    } label: {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    // Capture Button
                    Button {
                        viewModel.capturePhoto()
                    } label: {
                        ZStack {
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 80, height: 80)
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 68, height: 68)
                        }
                    }
                    .disabled(viewModel.selectedImages.count >= 3)
                    .opacity(viewModel.selectedImages.count >= 3 ? 0.5 : 1.0)
                    
                    // Camera Flip Button
                    Button {
                        viewModel.flipCamera()
                    } label: {
                        Image(systemName: "camera.rotate")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 40)
                
                // Instruction Text
                Text("TAP TO CAPTURE")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 20)
            }
        }
        .photosPicker(
            isPresented: $viewModel.showPhotoLibrary,
            selection: $viewModel.photoPickerItems,
            maxSelectionCount: 3 - viewModel.selectedImages.count,
            matching: .images
        )
        .onChange(of: viewModel.photoPickerItems) { _, newItems in
            viewModel.loadPhotoPickerImages(from: newItems)
        }
        .onAppear {
            viewModel.setupCamera()
        }
        .onDisappear {
            viewModel.stopCamera()
        }
    }
}

// MARK: - Thumbnail View

struct ThumbnailView: View {
    let image: UIImage
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 3)
                )
            
            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .background(Color.black.opacity(0.7))
                    .clipShape(Circle())
            }
            .offset(x: 8, y: -8)
        }
    }
}

// MARK: - Camera Preview View

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        context.coordinator.previewLayer = previewLayer
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let previewLayer = context.coordinator.previewLayer {
                previewLayer.frame = uiView.bounds
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}

// MARK: - View Model

@MainActor
class CameraPickerViewModel: NSObject, ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var showPhotoLibrary = false
    @Published var photoPickerItems: [PhotosPickerItem] = []
    
    let captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var currentCamera: AVCaptureDevice.Position = .back
    
    func setupCamera() {
        Task {
            await requestCameraPermission()
            await configureCaptureSession()
            startCamera()
        }
    }
    
    func startCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
    
    private func requestCameraPermission() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .notDetermined {
            _ = await AVCaptureDevice.requestAccess(for: .video)
        }
    }
    
    private func configureCaptureSession() async {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        // Add camera input
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCamera),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            captureSession.commitConfiguration()
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // Add photo output
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            photoOutput.maxPhotoQualityPrioritization = .quality
        }
        
        captureSession.commitConfiguration()
    }
    
    func capturePhoto() {
        guard selectedImages.count < 3 else { return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func flipCamera() {
        currentCamera = currentCamera == .back ? .front : .back
        
        // Remove existing inputs
        captureSession.inputs.forEach { input in
            captureSession.removeInput(input)
        }
        
        // Reconfigure with new camera
        Task {
            await configureCaptureSession()
        }
    }
    
    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
    
    func loadPhotoPickerImages(from items: [PhotosPickerItem]) {
        Task {
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        if selectedImages.count < 3 {
                            selectedImages.append(image)
                        }
                    }
                }
            }
            
            // Clear picker items
            await MainActor.run {
                photoPickerItems = []
            }
        }
    }
    
    func analyzeImages() {
        // TODO: Implement image analysis with AI
        print("Analyzing \(selectedImages.count) images...")
    }
}

// MARK: - Photo Capture Delegate

extension CameraPickerViewModel: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil,
              let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        Task { @MainActor in
            if selectedImages.count < 3 {
                selectedImages.append(image)
            }
        }
    }
}

// MARK: - Previews

#Preview("Camera Picker") {
    CameraPickerView { images in
        print("Selected \(images.count) images")
    }
}
