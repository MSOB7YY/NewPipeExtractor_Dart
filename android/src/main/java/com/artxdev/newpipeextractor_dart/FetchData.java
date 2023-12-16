package com.artxdev.newpipeextractor_dart;

import com.artxdev.newpipeextractor_dart.youtube.YoutubeLinkHandler;
import org.schabi.newpipe.extractor.InfoItem;
import org.schabi.newpipe.extractor.MediaFormat;
import org.schabi.newpipe.extractor.channel.ChannelInfoItem;
import org.schabi.newpipe.extractor.exceptions.ParsingException;
import org.schabi.newpipe.extractor.localization.DateWrapper;
import org.schabi.newpipe.extractor.playlist.PlaylistInfoItem;
import org.schabi.newpipe.extractor.services.youtube.ItagItem;
import org.schabi.newpipe.extractor.stream.*;

import java.time.OffsetDateTime;
import java.util.*;

public class FetchData {

    static public Map<String, String> fetchVideoInfo(final StreamExtractor extractor) {
        final Map<String, String> videoInformationMap = new HashMap<>();
        try {
            videoInformationMap.put("id", extractor.getId());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("url", extractor.getUrl());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("name", extractor.getName());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("uploaderName", extractor.getUploaderName());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("uploaderUrl", extractor.getUploaderUrl());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("uploaderAvatarUrl", getBestImage(extractor.getUploaderAvatars()).getUrl());
        } catch (final ParsingException ignored) {
        }
        try {
            final DateWrapper date = extractor.getUploadDate();
            if (date != null) {
                videoInformationMap.put("date", getDateString(date.offsetDateTime()));
                videoInformationMap.put("isDateApproximation", String.valueOf(date.isApproximation()));
            }
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("description", extractor.getDescription().getContent());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("length", String.valueOf(extractor.getLength()));
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("viewCount", String.valueOf(extractor.getViewCount()));
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("likeCount", String.valueOf(extractor.getLikeCount()));
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("dislikeCount", String.valueOf(extractor.getDislikeCount()));
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("category", extractor.getCategory());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("ageLimit", String.valueOf(extractor.getAgeLimit()));
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("tags", extractor.getTags().toString());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("thumbnailUrl", getBestImage(extractor.getThumbnails()).getUrl());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("uploaderSubscriberCount",
                    String.valueOf(extractor.getUploaderSubscriberCount()));
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("isUploaderVerified",
                    String.valueOf(extractor.isUploaderVerified()));
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("textualUploadDate", extractor.getTextualUploadDate());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("privacy", extractor.getPrivacy().name());
        } catch (final ParsingException ignored) {
        }
        try {
            videoInformationMap.put("isShortFormContent", String.valueOf(extractor.isShortFormContent()));
        } catch (final ParsingException ignored) {
        }
        return videoInformationMap;
    }

    static public String getDateString(final OffsetDateTime date) {
        return String.valueOf(date.toEpochSecond() * 1000);
    }

    static public Map<String, String> fetchAudioStreamInfo(final AudioStream stream) {
        final Map<String, String> streamMap = new HashMap<>();
        final MediaFormat format = stream.getFormat();
        final ItagItem tagItem = stream.getItagItem();

        streamMap.put("url", stream.getUrl());
        streamMap.put("id", stream.getId());
        streamMap.put("averageBitrate", String.valueOf(stream.getAverageBitrate()));
        if (format != null) {
            streamMap.put("formatName", format.name);
            streamMap.put("formatSuffix", format.suffix);
            streamMap.put("formatMimeType", format.mimeType);
        }


        streamMap.put("trackName", stream.getAudioTrackName());
        if (stream.getAudioTrackType() != null) {
            streamMap.put("trackType", stream.getAudioTrackType().name());
        }
        try {
            final Locale audioLocal = stream.getAudioLocale();
            if (audioLocal != null) {
                streamMap.put("language", audioLocal.getLanguage());
                streamMap.put("displayLanguage", audioLocal.getDisplayLanguage());
                streamMap.put("languageTag", audioLocal.toLanguageTag());
                streamMap.put("country", audioLocal.getCountry());
                streamMap.put("displayCountry", audioLocal.getDisplayCountry());
                streamMap.put("script", audioLocal.getScript());
                streamMap.put("displayScript", audioLocal.getDisplayScript());
            }
        } catch (Exception ignore) {
        }


        streamMap.put("qualityId", String.valueOf(stream.getId()));
        streamMap.put("codec", stream.getCodec());
        streamMap.put("bitrate", String.valueOf(stream.getBitrate()));
        streamMap.put("quality", stream.getQuality());

        if (tagItem != null) {
            streamMap.put("durationMS", String.valueOf(tagItem.getApproxDurationMs()));
            streamMap.put("sampleRate", String.valueOf(tagItem.getSampleRate()));
            streamMap.put("length", String.valueOf(tagItem.getContentLength()));
        }
        return streamMap;
    }

    static public Map<String, String> fetchVideoStreamInfo(final VideoStream stream) {
        final Map<String, String> streamMap = new HashMap<>();
        final MediaFormat format = stream.getFormat();
        final ItagItem tagItem = stream.getItagItem();

        streamMap.put("url", stream.getUrl());
        streamMap.put("id", stream.getId());
        streamMap.put("resolution", stream.getResolution());
        if (format != null) {
            streamMap.put("formatName", format.name);
            streamMap.put("formatSuffix", format.suffix);
            streamMap.put("formatMimeType", format.mimeType);
        }


        streamMap.put("qualityId", stream.getId());
        streamMap.put("fps", String.valueOf(stream.getFps()));
        streamMap.put("codec", stream.getCodec());
        streamMap.put("bitrate", String.valueOf(stream.getBitrate()));
        streamMap.put("height", String.valueOf(stream.getHeight()));
        streamMap.put("width", String.valueOf(stream.getWidth()));
        streamMap.put("quality", stream.getQuality());

        if (tagItem != null) {
            streamMap.put("averageBitrate", String.valueOf(tagItem.getAverageBitrate()));
            streamMap.put("durationMS", String.valueOf(tagItem.getApproxDurationMs()));
            streamMap.put("sampleRate", String.valueOf(tagItem.getSampleRate()));
            streamMap.put("length", String.valueOf(tagItem.getContentLength()));
        }
        return streamMap;
    }

    static public Map<String, String> fetchPlaylistInfoItem(final PlaylistInfoItem item) {
        final Map<String, String> itemMap = new HashMap<>();
        itemMap.put("name", item.getName());
        itemMap.put("uploaderName", item.getUploaderName());
        itemMap.put("uploaderUrl", item.getUploaderUrl());
        itemMap.put("url", item.getUrl());
        itemMap.put("id", YoutubeLinkHandler.getIdFromPlaylistUrl(item.getUrl()));
        itemMap.put("thumbnailUrl", getBestImage(item.getThumbnails()).getUrl());
        itemMap.put("streamCount", String.valueOf(item.getStreamCount()));
        itemMap.put("playlistType", item.getPlaylistType().name());
        itemMap.put("isUploaderVerified", String.valueOf(item.isUploaderVerified()));
//        itemMap.put("description", item.getDescription().getContent());
        return itemMap;
    }

    static public Map<String, String> fetchStreamInfoItem(final StreamInfoItem item) {
        final Map<String, String> itemMap = new HashMap<>();
        itemMap.put("id", YoutubeLinkHandler.getIdFromStreamUrl(item.getUrl()));
        itemMap.put("url", item.getUrl());
        itemMap.put("name", item.getName());
        itemMap.put("uploaderName", item.getUploaderName());
        itemMap.put("uploaderUrl", item.getUploaderUrl());
        itemMap.put("uploaderAvatarUrl", getBestImage(item.getUploaderAvatars()).getUrl());

        final DateWrapper date = item.getUploadDate();
        if (date != null) {
            itemMap.put("date", FetchData.getDateString(date.offsetDateTime()));
            itemMap.put("isDateApproximation", String.valueOf(date.isApproximation()));
        }

        itemMap.put("duration", String.valueOf(item.getDuration()));
        itemMap.put("viewCount", String.valueOf(item.getViewCount()));
        itemMap.put("isUploaderVerified", String.valueOf(item.isUploaderVerified()));
        itemMap.put("shortDescription", item.getShortDescription());

        itemMap.put("textualUploadDate", item.getTextualUploadDate());
        itemMap.put("isShortFormContent", String.valueOf(item.isShortFormContent()));
        itemMap.put("thumbnailUrl", getBestImage(item.getThumbnails()).getUrl());

        return itemMap;
    }

    static public Map<String, String> fetchStreamSegment(final StreamSegment segment) {
        final Map<String, String> itemMap = new HashMap<>();
        itemMap.put("url", segment.getUrl());
        itemMap.put("title", segment.getTitle());
        itemMap.put("previewUrl", segment.getPreviewUrl());
        itemMap.put("startTimeSeconds", String.valueOf(segment.getStartTimeSeconds()));
        return itemMap;
    }

    static public Map<String, Map<Integer, Map<String, String>>> fetchInfoItems(
            final List<InfoItem> items) {
        final List<StreamInfoItem> streamsList = new ArrayList<>();
        final List<PlaylistInfoItem> playlistsList = new ArrayList<>();
        final List<ChannelInfoItem> channelsList = new ArrayList<>();
        final Map<String, Map<Integer, Map<String, String>>> resultsList = new HashMap<>();
        for (InfoItem infoItem : items) {
            switch (infoItem.getInfoType()) {
                case STREAM:
                    final StreamInfoItem streamInfo = (StreamInfoItem) infoItem;
                    streamsList.add(streamInfo);
                    break;
                case CHANNEL:
                    final ChannelInfoItem channelInfo = (ChannelInfoItem) infoItem;
                    channelsList.add(channelInfo);
                    break;
                case PLAYLIST:
                    final PlaylistInfoItem playlistInfo = (PlaylistInfoItem) infoItem;
                    playlistsList.add(playlistInfo);
                    break;
                default:
                    break;
            }
        }

        // Extract into a map Stream Results
        final Map<Integer, Map<String, String>> streamResultsMap = new HashMap<>();
        if (!streamsList.isEmpty()) {
            for (int i = 0; i < streamsList.size(); i++) {
                final StreamInfoItem item = streamsList.get(i);
                streamResultsMap.put(i, fetchStreamInfoItem(item));
            }
        }
        resultsList.put("streams", streamResultsMap);

        // Extract into a map Channel Results
        final Map<Integer, Map<String, String>> channelResultsMap = new HashMap<>();
        if (!channelsList.isEmpty()) {
            for (int i = 0; i < channelsList.size(); i++) {
                final Map<String, String> itemMap = new HashMap<>();
                final ChannelInfoItem item = channelsList.get(i);
                itemMap.put("name", item.getName());
                itemMap.put("thumbnailUrl", getBestImage(item.getThumbnails()).getUrl());
                itemMap.put("url", item.getUrl());
                itemMap.put("id", YoutubeLinkHandler.getIdFromChannelUrl(item.getUrl()));
                itemMap.put("description", item.getDescription());
                itemMap.put("streamCount", String.valueOf(item.getStreamCount()));
                itemMap.put("subscriberCount", String.valueOf(item.getSubscriberCount()));
                itemMap.put("isVerified", String.valueOf(item.isVerified()));
                channelResultsMap.put(i, itemMap);
            }
        }
        resultsList.put("channels", channelResultsMap);

        // Extract into a map Playlist Results
        final Map<Integer, Map<String, String>> playlistResultsMap = new HashMap<>();
        if (!playlistsList.isEmpty()) {
            for (int i = 0; i < playlistsList.size(); i++) {
                final PlaylistInfoItem item = playlistsList.get(i);
                playlistResultsMap.put(i, fetchPlaylistInfoItem(item));
            }
        }
        resultsList.put("playlists", playlistResultsMap);
        return resultsList;
    }

    public static <T> T getBestImage(List<T> inputList) {
        if (inputList == null || inputList.isEmpty()) {
            return null; // or throw an exception, depending on your use case
        }
        return inputList.get(inputList.size() - 1);
    }
}
