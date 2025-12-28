import SwiftUI
import Speech
import AVFoundation
import Combine
import UIKit



/// Persistent bottom input bar for logging meals via text, photo, or voice.
/// Uses Asset-based colors for automatic Light/Dark mode support.
struct BottomPromptBar: View {
    @Binding var text: String
    var placeholder: String = "Add a meal"
    @Binding var selectedImages: [UIImage]
    
    var onCameraTap: () -> Void
    var onFavoritesTap: () -> Void
    var onSendTap: () -> Void
    
    @StateObject private var voiceRecorder = VoiceRecorderViewModel()
    @FocusState private var isTextFieldFocused: Bool
    @State private var textEditorHeight: CGFloat = 56
    
    // Exact color specifications
    private let microphoneActive = Color(red: 1.0, green: 0.23, blue: 0.19) // #FF3B30
    private let microphoneInactive = Color(red: 0.56, green: 0.56, blue: 0.58) // #8E8E93
    private let expandedPillBackground = Color(red: 0.95, green: 0.95, blue: 0.97) // #F2F2F7
    
    // Layout constants
    private let searchBarHeight: CGFloat = 56
    private let searchBarCornerRadius: CGFloat = 28
    private let pillHeight: CGFloat = 36
    private let pillTopOffset: CGFloat = -8
    private let cameraIconSize: CGFloat = 28
    private let stopButtonSize: CGFloat = 40
    private let microphoneIconSize: CGFloat = 24
    private let uploadButtonSize: CGFloat = 44
    private let editorLineHeight: CGFloat = 21 // approximate line height for 17pt system font
    private var maxEditorHeight: CGFloat { editorLineHeight * 4 + 24 } // 4 lines + vertical padding
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppTheme.Colors.divider)
            
            // Image Thumbnails Row (if images selected)
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                            ImageThumbnailView(image: image) {
                                removeImage(at: index)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(AppTheme.Colors.background)
                
                Divider()
                    .background(AppTheme.Colors.divider)
            }
            
            // Main container with language pill and search bar
            ZStack(alignment: .topLeading) {
                
                // Main search bar container
                HStack(spacing: 0) {
                    // Search bar content
                    HStack(spacing: 0) {
                        // Left side - Camera button (outline style)
                        Button(action: onCameraTap) {
                            Image(systemName: "camera")
                                .font(.system(size: cameraIconSize, weight: .regular))
                                .symbolVariant(.none) // Outline/stroke style
                                .foregroundColor(AppTheme.Colors.textPrimary)
                                .frame(width: uploadButtonSize, height: uploadButtonSize)
                        }
                        .accessibilityLabel("Add photo or attachment")
                        
                        Spacer()
                            .frame(width: 12)
                        
                        // Center - TextEditor with placeholder and dynamic height
                        ZStack(alignment: .topLeading) {  // Changed from .leading to .topLeading
                            // Placeholder text (shows when empty)
                            if text.isEmpty && !isTextFieldFocused {
                                Text(placeholder)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(microphoneInactive)
                                    .padding(.horizontal, 5)  // Match TextEditor's horizontal padding
                                    .padding(.vertical, 8)     // Match TextEditor's vertical padding
                                    .allowsHitTesting(false)   // Allow taps to pass through to TextEditor
                                    .transition(.opacity)
                            }
                            
                            // Actual TextEditor
                            TextEditor(text: $text)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(AppTheme.Colors.textPrimary)
                                .tint(AppTheme.Colors.secondary)
                                .scrollContentBackground(.hidden)  // Remove default gray background (iOS 16+)
                                .background(Color.clear)           // Ensure transparent background
                                .focused($isTextFieldFocused)
                                .frame(
                                    minHeight: searchBarHeight,
                                    maxHeight: min(textEditorHeight, maxEditorHeight)
                                )
                                .background(
                                    // Measure intrinsic height by mirroring text in a hidden Text
                                    Text(text.isEmpty ? " " : text)
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(.clear)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            GeometryReader { proxy in
                                                Color.clear
                                                    .onAppear {
                                                        textEditorHeight = max(searchBarHeight, proxy.size.height + 24)
                                                    }
                                                    .onChange(of: text) { _, _ in
                                                        textEditorHeight = max(searchBarHeight, proxy.size.height + 24)
                                                    }
                                            }
                                        )
                                        .hidden()
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(.easeInOut(duration: 0.2), value: textEditorHeight)  // Smooth height changes
                        .animation(.easeIn(duration: 0.1), value: text.isEmpty)         // Smooth placeholder fade
                        Spacer()
                            .frame(width: 12)
                        
                        // Right side - Stop button (when recording) or Microphone button
                        if voiceRecorder.isRecording {
                            // Red stop button (no background overlays) with mic icon
                            Button {
                                handleStopRecording()
                            } label: {
                                ZStack {
                                    Image(systemName: "mic.fill")
                                        .font(.system(size: microphoneIconSize, weight: .regular))
                                        .foregroundColor(microphoneActive)
                                        .frame(width: uploadButtonSize, height: uploadButtonSize)
                                }
                            }
                            .accessibilityLabel("Stop recording")
                            .transition(.scale.combined(with: .opacity))
                        } else {
                            // Microphone button (inactive state)
                            Button {
                                handleMicrophoneTap()
                            } label: {
                                Image(systemName: "mic.fill")
                                    .font(.system(size: microphoneIconSize, weight: .regular))
                                    .foregroundColor(microphoneInactive)
                                    .frame(width: uploadButtonSize, height: uploadButtonSize)
                            }
                            .accessibilityLabel("Start voice input")
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(minHeight: searchBarHeight, maxHeight: min(textEditorHeight, maxEditorHeight))
                    .background(AppTheme.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: searchBarCornerRadius, style: .continuous))
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                    
                    Spacer()
                        .frame(width: 12)
                    
                    // Far right - Upload/scroll button (outside search bar)
                    Button(action: hasContent ? onSendTap : onFavoritesTap) {
                        Image(systemName: hasContent ? "arrow.up" : "heart.fill")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: uploadButtonSize, height: uploadButtonSize)
                            .background(microphoneInactive)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel(hasContent ? "Submit" : "Favorites")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.Colors.background)
        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: voiceRecorder.isRecording)
        .onChange(of: voiceRecorder.transcribedText) { _, newValue in
            text = newValue
        }
        .onChange(of: voiceRecorder.isRecording) { _, isRecording in
            if isRecording || !text.isEmpty {
                // no cursor blink anymore
            } else {
                // no cursor blink anymore
            }
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
    
    /// Determines if there's any content (text or images) to submit
    private var hasContent: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !selectedImages.isEmpty
    }
    
    private func handleMicrophoneTap() {
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Small delay then start recording
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            voiceRecorder.startRecording()
        }
    }
    
    private func handleStopRecording() {
        voiceRecorder.stopRecording()
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
}

// MARK: - Image Thumbnail View

struct ImageThumbnailView: View {
    let image: UIImage
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(AppTheme.Colors.divider, lineWidth: 1)
                )
            
            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.7))
                            .frame(width: 32, height: 32)
                    )
            }
            .offset(x: 8, y: -8)
        }
    }
}

// MARK: - Voice Recorder View Model

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
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Locale.preferredLanguages.first ?? "en-US"))
    }
    
    func startRecording() {
        // Check speech recognition authorization
        let speechAuthStatus = SFSpeechRecognizer.authorizationStatus()
        
        switch speechAuthStatus {
        case .authorized:
            // Check microphone permission
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { [weak self] granted in
                    DispatchQueue.main.async {
                        if granted {
                            self?.beginRecording()
                        } else {
                            self?.showMicrophonePermissionAlert = true
                        }
                    }
                }
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                    DispatchQueue.main.async {
                        if granted {
                            self?.beginRecording()
                        } else {
                            self?.showMicrophonePermissionAlert = true
                        }
                    }
                }
            }
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if authStatus == .authorized {
                        self.startRecording()
                    } else {
                        self.showMicrophonePermissionAlert = true
                    }
                }
            }
        default:
            showMicrophonePermissionAlert = true
        }
    }
    
    private func beginRecording() {
        // Cancel any ongoing recognition task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Stop audio engine if running
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            return
        }
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure audio engine
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
                    // Always update with the latest transcription
                    self.transcribedText = result.bestTranscription.formattedString
                }
                
                // If result is final, we can stop early
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
        // Mark as not recording immediately to update UI
        isRecording = false
        
        // End the recognition request (this triggers final result)
        recognitionRequest?.endAudio()
        
        // Give a brief moment for final transcription to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            // Stop audio engine
            if self.audioEngine.isRunning {
                self.audioEngine.stop()
            }
            
            // Remove tap
            self.audioEngine.inputNode.removeTap(onBus: 0)
            
            // Finish recognition task (don't cancel, let it complete)
            self.recognitionTask?.finish()
            
            // Clear references
            self.recognitionRequest = nil
            self.recognitionTask = nil
            
            // Deactivate audio session
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            } catch {
                // Silently fail
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

