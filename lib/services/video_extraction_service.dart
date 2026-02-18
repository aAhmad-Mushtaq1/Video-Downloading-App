import 'dart:io';
import 'dart:convert';
import '../models/video_info.dart';
import '../core/utils/url_parser.dart';

class VideoExtractionService {
  Future<VideoInfo> extractVideoInfo(String url) async {
    // In a real app, this would call yt-dlp via process
    // For now, we'll return mock data based on the URL
    
    final platform = UrlParser.detectPlatform(url) ?? 'Unknown';
    
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data for demonstration
    return VideoInfo(
      url: url,
      title: _getMockTitle(platform),
      thumbnail: _getMockThumbnail(platform),
      duration: '3:45',
      author: _getMockAuthor(platform),
      platform: platform,
      availableQualities: [
        const VideoQuality(label: '360p', resolution: '640x360', fileSize: '25 MB'),
        const VideoQuality(label: '480p', resolution: '854x480', fileSize: '45 MB'),
        const VideoQuality(label: '720p', resolution: '1280x720', fileSize: '85 MB'),
        const VideoQuality(label: '1080p', resolution: '1920x1080', fileSize: '150 MB'),
      ],
      availableFormats: ['mp4', 'mkv', 'webm', 'mp3'],
    );
  }
  
  Future<VideoInfo> extractWithYtDlp(String url) async {
    try {
      // Call yt-dlp to get video info
      final result = await Process.run(
        'yt-dlp',
        [
          '--dump-json',
          '--no-playlist',
          url,
        ],
      );
      
      if (result.exitCode != 0) {
        throw Exception('Failed to extract video info: ${result.stderr}');
      }
      
      final json = jsonDecode(result.stdout as String) as Map<String, dynamic>;
      
      return VideoInfo(
        url: url,
        title: json['title'] as String? ?? 'Unknown',
        thumbnail: json['thumbnail'] as String?,
        duration: json['duration']?.toString(),
        author: json['uploader'] as String?,
        platform: UrlParser.detectPlatform(url) ?? 'Unknown',
        availableQualities: _parseQualities(json),
        availableFormats: ['mp4', 'mkv', 'webm', 'mp3'],
      );
    } catch (e) {
      // Fallback to mock data if yt-dlp is not available
      return extractVideoInfo(url);
    }
  }
  
  List<VideoQuality> _parseQualities(Map<String, dynamic> json) {
    final formats = json['formats'] as List<dynamic>? ?? [];
    final qualities = <VideoQuality>[];
    final seen = <String>{};
    
    for (final format in formats) {
      final formatMap = format as Map<String, dynamic>;
      final height = formatMap['height'] as int?;
      if (height == null) continue;
      
      final label = '${height}p';
      if (seen.contains(label)) continue;
      seen.add(label);
      
      qualities.add(VideoQuality(
        label: label,
        resolution: '${formatMap['width'] ?? '?'}x$height',
        fileSize: formatMap['filesize']?.toString(),
      ));
    }
    
    return qualities;
  }
  
  String _getMockTitle(String platform) {
    switch (platform) {
      case 'YouTube':
        return 'Amazing Tutorial - Learn Something New';
      case 'TikTok':
        return 'Viral TikTok Video';
      case 'Instagram':
        return 'Instagram Reel';
      default:
        return 'Sample Video Title';
    }
  }
  
  String _getMockThumbnail(String platform) {
    // Return a placeholder image URL
    return 'https://via.placeholder.com/480x360.png?text=${platform}';
  }
  
  String _getMockAuthor(String platform) {
    switch (platform) {
      case 'YouTube':
        return 'Cool Channel';
      case 'TikTok':
        return '@tiktokuser';
      case 'Instagram':
        return '@instagramuser';
      default:
        return 'Content Creator';
    }
  }
}
