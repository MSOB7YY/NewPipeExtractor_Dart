package com.artxdev.newpipeextractor_dart.youtube;

import android.util.Log;
import org.schabi.newpipe.extractor.localization.DateWrapper;
import org.schabi.newpipe.extractor.playlist.PlaylistExtractor;
import org.schabi.newpipe.extractor.services.youtube.YoutubeParsingHelper;
import org.schabi.newpipe.extractor.stream.StreamInfoItem;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import static org.schabi.newpipe.extractor.ServiceList.YouTube;

public class YoutubePlaylistExtractorImpl {

    static private PlaylistExtractor extractor;

    static public Map<String, String> getPlaylistDetails(final String url) throws Exception {
        Log.d("EXTRACTOR: ", "getPlaylistDetails: " + url);
        YoutubeParsingHelper.resetClientVersionAndKey();
        YoutubeParsingHelper.setNumberGenerator(new Random(1));
        extractor = YouTube.getPlaylistExtractor(url);
        extractor.fetchPage();
        final Map<String, String> playlistDetails = new HashMap<>();
        playlistDetails.put("name", extractor.getName());
        playlistDetails.put("thumbnailUrl", extractor.getThumbnailUrl());
        playlistDetails.put("bannerUrl", extractor.getBannerUrl());
        try {
            playlistDetails.put("uploaderName", extractor.getUploaderName());
        } catch (final Exception e) {
            playlistDetails.put("uploaderName", "Unknown");
        }
        try {
            playlistDetails.put("uploaderAvatarUrl", extractor.getUploaderAvatarUrl());
        } catch (final Exception e) {
            playlistDetails.put("uploaderAvatarUrl", null);
        }
        try {
            playlistDetails.put("uploaderUrl", extractor.getUploaderUrl());
        } catch (final Exception e) {
            playlistDetails.put("uploaderUrl", null);
        }
        playlistDetails.put("streamCount", String.valueOf(extractor.getStreamCount()));
        playlistDetails.put("id", extractor.getId());
        playlistDetails.put("url", extractor.getUrl());
        return playlistDetails;
    }

    static public Map<Integer, Map<String, String>> getPlaylistStreams(final String url)
            throws Exception {
        extractor = YouTube.getPlaylistExtractor(url);
        extractor.fetchPage();
        final List<StreamInfoItem> items = extractor.getInitialPage().getItems();
        return _fetchResultsFromItems(items);
    }

    static private Map<Integer, Map<String, String>> _fetchResultsFromItems(
            final List<StreamInfoItem> items) {
        final Map<Integer, Map<String, String>> playlistResults = new HashMap<>();
        for (int i = 0; i < items.size(); i++) {
            final Map<String, String> itemMap = new HashMap<>();
            final StreamInfoItem item = items.get(i);
            itemMap.put("name", item.getName());
            itemMap.put("uploaderName", item.getUploaderName());
            itemMap.put("uploaderUrl", item.getUploaderUrl());
            itemMap.put("uploadDate", item.getTextualUploadDate());

            final DateWrapper date = item.getUploadDate();
            if (date != null) {
                itemMap.put("date", date.offsetDateTime().format(DateTimeFormatter.ISO_DATE_TIME));
            }

            itemMap.put("thumbnailUrl", item.getThumbnailUrl());
            itemMap.put("duration", String.valueOf(item.getDuration()));
            itemMap.put("viewCount", String.valueOf(item.getViewCount()));
            itemMap.put("url", item.getUrl());
            itemMap.put("id", YoutubeLinkHandler.getIdFromStreamUrl(item.getUrl()));
            playlistResults.put(i, itemMap);
        }
        return playlistResults;
    }

}
