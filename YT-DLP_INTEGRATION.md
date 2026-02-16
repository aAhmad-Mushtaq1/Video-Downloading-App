# YT-DLP Integration Guide

This document explains how to integrate `yt-dlp` for video downloading functionality.

## What is yt-dlp?

`yt-dlp` is a fork of youtube-dl with additional features and fixes. It supports downloading videos from 1700+ websites.

## Installation Methods

### Method 1: Pre-bundled Binary (Recommended for Production)

1. Download the appropriate yt-dlp binary for your platform:
   - Windows: `yt-dlp.exe`
   - macOS/Linux: `yt-dlp`

2. Place the binary in your app's assets or bundle it with your app

3. Update the service to use the bundled binary path

### Method 2: System Installation (Development)

#### Windows
```bash
winget install yt-dlp
# or
pip install yt-dlp
```

#### macOS
```bash
brew install yt-dlp
# or
pip3 install yt-dlp
```

#### Linux
```bash
sudo apt install yt-dlp
# or
pip3 install yt-dlp
```

## Usage in Flutter

The `VideoExtractionService` class already has integration code. Here's how it works:

### Extract Video Information
```dart
final service = VideoExtractionService();
final videoInfo = await service.extractWithYtDlp('https://youtube.com/watch?v=...');
```

### Download Video
```dart
// Using yt-dlp directly
final result = await Process.run(
  'yt-dlp',
  [
    '-f', 'bestvideo[height<=720]+bestaudio/best[height<=720]',
    '-o', '/path/to/output.mp4',
    url,
  ],
);
```

## Command Line Arguments

### Get Video Info
```bash
yt-dlp --dump-json --no-playlist URL
```

### Download Video
```bash
# Download best quality
yt-dlp -f 'bestvideo+bestaudio' URL

# Download specific quality
yt-dlp -f 'bestvideo[height<=720]+bestaudio' URL

# Download as MP3
yt-dlp -x --audio-format mp3 URL

# Download with progress
yt-dlp --newline --progress URL
```

## Format Selection

- `best`: Best quality (video+audio)
- `bestvideo[height<=720]`: Best video up to 720p
- `bestaudio`: Best audio only
- `worst`: Lowest quality

## Platform-Specific Notes

### Android
1. Bundle yt-dlp binary in `assets/bin/`
2. Extract to app's cache directory on first run
3. Set executable permissions
4. Use extracted path in Process.run()

### iOS
- iOS restrictions may limit subprocess execution
- Consider using alternative HTTP-based download APIs
- Or implement server-side solution

### Desktop (Windows/macOS/Linux)
- Can use system-installed yt-dlp
- Or bundle the binary with the app
- Set proper executable permissions on macOS/Linux

## Error Handling

```dart
try {
  final result = await Process.run('yt-dlp', args);
  if (result.exitCode != 0) {
    throw Exception('Download failed: ${result.stderr}');
  }
} catch (e) {
  // Fallback to mock data or alternative method
}
```

## Progress Tracking

Parse yt-dlp output for progress:

```dart
final process = await Process.start('yt-dlp', [
  '--newline',
  '--progress',
  url,
]);

process.stdout.transform(utf8.decoder).listen((data) {
  // Parse progress from output
  // Example: [download]  45.2% of 100.00MiB at 5.00MiB/s ETA 00:11
});
```

## Alternative: HTTP Downloads

For simpler implementation without yt-dlp:

1. Use video platform APIs to get direct video URLs
2. Download using Dio package
3. Implement progress tracking with Dio's onReceiveProgress

## Recommended Approach

For maximum compatibility:

1. **Primary**: Use yt-dlp for desktop platforms
2. **Fallback**: Use HTTP downloads with platform APIs for mobile
3. **Mock Data**: Use mock data during development/testing

## Current Implementation

The app currently uses mock data for demonstration. To enable real downloading:

1. Install yt-dlp on your system
2. Update `VideoExtractionService.extractVideoInfo()` to call `extractWithYtDlp()`
3. Implement proper download progress tracking in `DownloadService`

## Resources

- [yt-dlp GitHub](https://github.com/yt-dlp/yt-dlp)
- [yt-dlp Documentation](https://github.com/yt-dlp/yt-dlp#readme)
- [Supported Sites List](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)
