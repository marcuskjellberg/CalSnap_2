//
//  CameraPickerView.swift
//  CalSnap
//
//  Full-screen camera interface for capturing meal photos
//

import SwiftUI
import PhotosUI
import AVFoundation
import Speech
import Combine

struct CameraPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CameraPickerViewModel()
    
    var onImagesSelected: ([UIImage]) -> Void
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreviewView(session: viewModel.captureSession)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar with Action Buttons
                HStack(spacing: 12) {
                    // Close Button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: Circle())
                            .environment(\.colorScheme, .dark)
                    }
                    
                    Spacer()
                    
                    // Action Buttons - Only show when images are selected
                    if !viewModel.selectedImages.isEmpty {
                        Button {
                            onImagesSelected(viewModel.selectedImages)
                            dismiss()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 15, weight: .semibold))
                                Text("Done")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.green, in: Capsule())
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                Spacer()
                
                // Photo Buckets - Always show 3 slots centered
                HStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { index in
                        PhotoBucketView(
                            image: index < viewModel.selectedImages.count ? viewModel.selectedImages[index] : nil,
                            index: index
                        ) {
                            if index < viewModel.selectedImages.count {
                                viewModel.removeImage(at: index)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 24)
                
                // Bottom Controls
                HStack(spacing: 60) {
                    // Photo Library Button
                    Button {
                        viewModel.showPhotoLibrary = true
                    } label: {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(.ultraThinMaterial, in: Circle())
                            .environment(\.colorScheme, .dark)
                    }
                    
                    // Capture Button
                    Button {
                        viewModel.capturePhoto()
                    } label: {
                        ZStack {
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 4)
                                .frame(width: 75, height: 75)
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 63, height: 63)
                        }
                    }
                    .disabled(viewModel.selectedImages.count >= 3)
                    .opacity(viewModel.selectedImages.count >= 3 ? 0.5 : 1.0)
                    
                    // Flip Camera Button
                    Button {
                        viewModel.flipCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(.ultraThinMaterial, in: Circle())
                            .environment(\.colorScheme, .dark)
                    }
                }
                .padding(.bottom, 24)
                
                // Instruction Text
                Text(viewModel.selectedImages.isEmpty ? "TAP TO CAPTURE" : "TAP DONE TO CONTINUE")
                    .font(.system(size: 13, weight: .medium))
                    .tracking(1.2)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 40)
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

// MARK: - Photo Bucket View

struct PhotoBucketView: View {
    let image: UIImage?
    let index: Int
    let onDelete: () -> Void
    
    var body: some View {
        ZStack {
            if let image = image {
                // Filled bucket with image
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 3)
                        )
                    
                    // Delete Button
                    Button(action: onDelete) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.6)).padding(4))
                    }
                    .offset(x: 8, y: -8)
                }
            } else {
                // Empty bucket placeholder
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 90, height: 90)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                            .foregroundColor(.white.opacity(0.4))
                    )
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.4))
                    )
            }
        }
        .frame(width: 90, height: 90)
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
final class CameraPickerViewModel: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var selectedImages: [UIImage] = []
    @Published var showPhotoLibrary = false
    @Published var photoPickerItems: [PhotosPickerItem] = []
    
    // MARK: - Camera Properties
    
    let captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var currentCamera: AVCaptureDevice.Position = .back
    
    // MARK: - Initialization
    
    override init() {
        super.init()
    }
    
    // MARK: - Camera Setup
    
    func setupCamera() {
        Task {
            await requestCameraPermission()
            await configureCaptureSession()
            startCamera()
        }
    }
    
    func startCamera() {
        Task.detached { [weak self] in
            guard let self else { return }
            await self.captureSession.startRunning()
        }
    }
    
    func stopCamera() {
        Task.detached { [weak self] in
            guard let self else { return }
            await self.captureSession.stopRunning()
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
        
        // Configure to not use audio (allows separate audio usage)
        captureSession.automaticallyConfiguresApplicationAudioSession = false
        
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
    
    // MARK: - Photo Capture
    
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
    
    // MARK: - Image Management
    
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
