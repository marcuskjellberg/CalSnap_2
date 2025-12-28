import SwiftUI
import Speech
import AVFoundation
import UIKit
import Combine

// MARK: - Bottom Prompt Bar

/// Persistent bottom input bar for logging meals via text, photo, or voice.
/// 
/// Handles three input methods:
/// - Text input via TextEditor (single line default, expands to 4 lines max)
/// - Voice transcription via speech recognition
/// - Photo capture (images displayed above bar)
///
/// Uses AppTheme for all styling to ensure consistent design system compliance.
/// Focus is dismissed when tapping outside the editor.
struct BottomPromptBar: View {
    @Binding var text: String
    var placeholder: String = "Add a meal"
    @Binding var selectedImages: [UIImage]
    
    var onCameraTap: () -> Void
    var onFavoritesTap: () -> Void
    var onSendTap: () -> Void
    
    // Tracks whether the TextEditor inside the pill is focused (used to show/hide placeholder and dismiss keyboard)
    @FocusState private var isTextFieldFocused: Bool
    // Current measured height of the TextEditor content (drives dynamic resizing of the pill)
    @State private var textEditorHeight: CGFloat = 40
    @StateObject private var voiceRecorder = VoiceRecorderViewModel()
    
    // MARK: - Layout Constants
    
    // Minimum height for the entire pill (camera + editor + mic) when showing a single line
    private let searchBarMinHeight: CGFloat = 40 // Single line height (21pt text + 19pt padding)
    // Size for standard icons (e.g., microphone glyph)
    private let iconSize: CGFloat = 24
    // Slightly larger size used for the camera icon to improve visual balance
    private let cameraIconSize: CGFloat = 28
    // Tap target size for the circular buttons to meet accessibility guidelines
    private let buttonSize: CGFloat = 44
    // Approximate line height used to estimate TextEditor growth per line
    private let editorLineHeight: CGFloat = 21 // Approximate line height for 17pt system font
    // Maximum height the TextEditor (and pill) can grow to (caps at ~4 lines)
    private var maxEditorHeight: CGFloat { editorLineHeight * 4 + 24 } // 4 lines + vertical padding
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppTheme.Colors.divider)
            
            // Image thumbnails row (appears when photos are selected)
            if !selectedImages.isEmpty {
                ImageThumbnailsRow(images: selectedImages, onDelete: removeImage)
            }
            
            // Main search bar container
            HStack(spacing: AppTheme.Spacing.sm) {
                SearchBarContent(
                    text: $text,
                    placeholder: placeholder,
                    isTextFieldFocused: $isTextFieldFocused,
                    textEditorHeight: $textEditorHeight,
                    isRecording: voiceRecorder.isRecording,
                    minHeight: searchBarMinHeight,
                    maxHeight: maxEditorHeight,
                    onCameraTap: onCameraTap,
                    onMicrophoneTap: handleMicrophoneTap,
                    onStopRecording: handleStopRecording
                )
                
                // Upload/favorites button (outside search bar)
                UploadButton(hasContent: hasContent, onTap: hasContent ? onSendTap : onFavoritesTap)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
        .background(AppTheme.Colors.background)
        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: voiceRecorder.isRecording)
        .onChange(of: voiceRecorder.transcribedText) { _, newValue in
            text = newValue
        }
        .alert("Microphone Access Required", isPresented: $voiceRecorder.showMicrophonePermissionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        } message: {
            Text("CalSnap needs microphone access to transcribe your voice. Please enable it in Settings.")
        }
    }
    
    // MARK: - Private Helpers
    
    private var hasContent: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !selectedImages.isEmpty
    }
    
    private func handleMicrophoneTap() {
        // Provide haptic feedback before starting to give immediate user feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Small delay ensures haptic completes before audio session changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            voiceRecorder.startRecording()
        }
    }
    
    private func handleStopRecording() {
        voiceRecorder.stopRecording()
        
        // Success haptic confirms recording completion
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
}

// MARK: - Search Bar Content

/// Internal component for the search bar input area.
/// Encapsulates camera button, text editor, and microphone/stop button.
private struct SearchBarContent: View {
    @Binding var text: String
    let placeholder: String
    var isTextFieldFocused: FocusState<Bool>.Binding
    @Binding var textEditorHeight: CGFloat
    let isRecording: Bool
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let onCameraTap: () -> Void
    let onMicrophoneTap: () -> Void
    let onStopRecording: () -> Void
    
    private let cameraIconSize: CGFloat = 28
    private let iconSize: CGFloat = 24
    private let buttonSize: CGFloat = 44
    
    var body: some View {
        HStack(spacing: 0) {
            CameraButton(
                size: buttonSize,
                iconSize: cameraIconSize,
                onTap: {
                    isTextFieldFocused.wrappedValue = false
                    onCameraTap()
                }
            )
            
            Spacer().frame(width: AppTheme.Spacing.sm)
            
            TextEditorWithPlaceholder(
                text: $text,
                placeholder: placeholder,
                isFocused: isTextFieldFocused,
                height: $textEditorHeight,
                minHeight: minHeight,
                maxHeight: maxHeight
            )
            
            Spacer().frame(width: AppTheme.Spacing.sm)
            
            if isRecording {
                StopRecordingButton(
                    size: buttonSize,
                    iconSize: iconSize,
                    onTap: {
                        isTextFieldFocused.wrappedValue = false
                        onStopRecording()
                    }
                )
                .transition(.scale.combined(with: .opacity))
            } else {
                MicrophoneButton(
                    size: buttonSize,
                    iconSize: iconSize,
                    onTap: {
                        isTextFieldFocused.wrappedValue = false
                        onMicrophoneTap()
                    }
                )
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .frame(minHeight: minHeight, maxHeight: maxHeight)
        .background(AppTheme.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }
}

// MARK: - Text Editor with Placeholder

/// TextEditor wrapper that displays a placeholder when empty and measures content height.
/// Uses a hidden Text view to measure intrinsic content height for dynamic sizing.
private struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    let placeholder: String
    var isFocused: FocusState<Bool>.Binding
    @Binding var height: CGFloat
    let minHeight: CGFloat
    let maxHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder overlay (only visible when empty and not focused)
            if text.isEmpty && !isFocused.wrappedValue {
                Text(placeholder)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 8)
                    .allowsHitTesting(false) // Allow taps to pass through to TextEditor
                    .transition(.opacity)
            }
            
            // Actual TextEditor
            TextEditor(text: $text)
                .font(AppTheme.Typography.bodyMedium)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .tint(AppTheme.Colors.textPrimary) // Cursor matches text color
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .focused(isFocused)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
                .background(heightMeasurer)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut(duration: 0.2), value: height)
        .animation(.easeIn(duration: 0.1), value: text.isEmpty)
    }
    
    // Hidden Text view used to measure content height
    // SwiftUI TextEditor doesn't expose intrinsic content size, so we mirror the text
    private var heightMeasurer: some View {
        Text(text.isEmpty ? " " : text)
            .font(AppTheme.Typography.bodyMedium)
            .foregroundColor(.clear)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            updateHeight(from: proxy.size.height)
                        }
                        .onChange(of: text) { _, _ in
                            updateHeight(from: proxy.size.height)
                        }
                }
            )
            .hidden()
    }
    
    private func updateHeight(from contentHeight: CGFloat) {
        height = max(minHeight, contentHeight + 24) // 24pt for vertical padding
    }
}

// MARK: - Camera Button

private struct CameraButton: View {
    let size: CGFloat
    let iconSize: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "camera")
                .font(.system(size: iconSize, weight: .regular))
                .symbolVariant(.none) // Outline/stroke style
                .foregroundColor(AppTheme.Colors.textPrimary)
                .frame(width: size, height: size)
        }
        .accessibilityLabel("Add photo or attachment")
    }
}

// MARK: - Microphone Button

private struct MicrophoneButton: View {
    let size: CGFloat
    let iconSize: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "mic.fill")
                .font(.system(size: iconSize, weight: .regular))
                .foregroundColor(AppTheme.Colors.textTertiary)
                .frame(width: size, height: size)
        }
        .accessibilityLabel("Start voice input")
    }
}

// MARK: - Stop Recording Button

private struct StopRecordingButton: View {
    let size: CGFloat
    let iconSize: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "mic.fill")
                .font(.system(size: iconSize, weight: .regular))
                .foregroundColor(AppTheme.Colors.destructive)
                .frame(width: size, height: size)
        }
        .accessibilityLabel("Stop recording")
    }
}

// MARK: - Upload Button

private struct UploadButton: View {
    let hasContent: Bool
    let onTap: () -> Void
    
    private let size: CGFloat = 44
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: hasContent ? "arrow.up" : "heart.fill")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background(AppTheme.Colors.textTertiary)
                .clipShape(Circle())
        }
        .accessibilityLabel(hasContent ? "Submit" : "Favorites")
    }
}

// MARK: - Image Thumbnails Row

private struct ImageThumbnailsRow: View {
    let images: [UIImage]
    let onDelete: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.xs) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        ImageThumbnailView(image: image) {
                            onDelete(index)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
            }
            .background(AppTheme.Colors.background)
            
            Divider()
                .background(AppTheme.Colors.divider)
        }
    }
}

// MARK: - Image Thumbnail View

private struct ImageThumbnailView: View {
    let image: UIImage
    let onDelete: () -> Void
    
    private let size: CGFloat = 90
    private let cornerRadius: CGFloat = 24
    private let deleteButtonSize: CGFloat = 32
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(AppTheme.Colors.divider, lineWidth: 1)
                )
            
            // Delete button
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.7))
                            .frame(width: deleteButtonSize, height: deleteButtonSize)
                    )
            }
            .offset(x: 8, y: -8)
        }
    }
}

// MARK: - Voice Recorder View Model

/// Manages speech recognition state and audio recording.
/// Handles permissions, audio session configuration, and real-time transcription.
@MainActor
class VoiceRecorderViewModel: NSObject, ObservableObject {
    
    @Published var isRecording = false
    @Published var transcribedText = ""
    @Published var showMicrophonePermissionAlert = false
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override init() {
        super.init()
        // Initialize with device's preferred language for better accuracy
        let preferredLocale = Locale(identifier: Locale.preferredLanguages.first ?? "en-US")
        speechRecognizer = SFSpeechRecognizer(locale: preferredLocale)
    }
    
    func startRecording() {
        let speechAuthStatus = SFSpeechRecognizer.authorizationStatus()
        
        switch speechAuthStatus {
        case .authorized:
            requestMicrophonePermission()
        case .notDetermined:
            // Request speech recognition permission first
            SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if authStatus == .authorized {
                        self.startRecording() // Recursively call after permission granted
                    } else {
                        self.showMicrophonePermissionAlert = true
                    }
                }
            }
        default:
            showMicrophonePermissionAlert = true
        }
    }
    
    private func requestMicrophonePermission() {
        let requestPermission: (Bool) -> Void = { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.beginRecording()
                } else {
                    self?.showMicrophonePermissionAlert = true
                }
            }
        }
        
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission(completionHandler: requestPermission)
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission(requestPermission)
        }
    }
    
    private func beginRecording() {
        // Clean up any existing recognition task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Stop audio engine if already running
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // Configure audio session for recording
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            return
        }
        
        // Create recognition request with partial results enabled for real-time updates
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure audio engine tap
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            inputNode.removeTap(onBus: 0)
            return
        }
        
        // Start recognition task
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            stopRecording()
            return
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                DispatchQueue.main.async {
                    self.transcribedText = result.bestTranscription.formattedString
                }
                
                // Auto-stop when final result is received
                if result.isFinal {
                    DispatchQueue.main.async {
                        self.stopRecording()
                    }
                }
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    self.stopRecording()
                }
            }
        }
    }
    
    func stopRecording() {
        isRecording = false
        recognitionRequest?.endAudio()
        
        // Brief delay allows final transcription to complete before cleanup
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            if self.audioEngine.isRunning {
                self.audioEngine.stop()
            }
            
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionTask?.finish()
            self.recognitionRequest = nil
            self.recognitionTask = nil
            
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            } catch {
                // Silently fail - audio session cleanup is not critical
            }
        }
    }
}

// MARK: - Previews

#Preview("Empty State") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant(""),
            selectedImages: .constant([]),
            onCameraTap: {},
            onFavoritesTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
}

#Preview("With Text") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant("Coffee with milk"),
            selectedImages: .constant([]),
            onCameraTap: {},
            onFavoritesTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
}

#Preview("Recording State") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant("Hallå nu är jag klar"),
            selectedImages: .constant([]),
            onCameraTap: {},
            onFavoritesTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant(""),
            selectedImages: .constant([]),
            onCameraTap: {},
            onFavoritesTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}

#Preview("Large Dynamic Type") {
    VStack {
        Spacer()
        BottomPromptBar(
            text: .constant("Morning smoothie"),
            selectedImages: .constant([]),
            onCameraTap: {},
            onFavoritesTap: {},
            onSendTap: {}
        )
    }
    .background(AppTheme.Colors.background)
    .environment(\.dynamicTypeSize, .accessibility3)
}

