package com.artxdev.newpipeextractor_dart.youtube;

import android.util.Log;
import com.artxdev.newpipeextractor_dart.FetchData;
import org.schabi.newpipe.extractor.ListExtractor;
import org.schabi.newpipe.extractor.playlist.PlaylistExtractor;
import org.schabi.newpipe.extractor.services.youtube.YoutubeParsingHelper;
import org.schabi.newpipe.extractor.stream.StreamInfoItem;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import static org.schabi.newpipe.extractor.ServiceList.YouTube;

public class YoutubePlaylistExtractorImpl {

    static private final HashMap<String, PlaylistExtractor> extractors = new HashMap<>();
    static private final HashMap<String, ListExtractor.InfoItemsPage<StreamInfoItem>> currentPages = new HashMap<>();

    static public Map<String, String> getPlaylistDetails(final String url) throws Exception {
        Log.d("EXTRACTOR: ", "getPlaylistDetails: " + url);
        YoutubeParsingHelper.resetClientVersionAndKey();
        YoutubeParsingHelper.setNumberGenerator(new Random(1));

        final PlaylistExtractor oldextractor = extractors.get(url);
        if (oldextractor == null) {
            extractors.put(url, YouTube.getPlaylistExtractor(url));
        }

        final PlaylistExtractor extractor = extractors.get(url);
        final Map<String, String> playlistDetails = new HashMap<>();
        if (extractor != null) {
            extractor.fetchPage();
            playlistDetails.put("name", extractor.getName());
            playlistDetails.put("thumbnailUrl", FetchData.getBestImage(extractor.getThumbnails()).getUrl());
            playlistDetails.put("bannerUrl", FetchData.getBestImage(extractor.getBanners()).getUrl());
            try {
                playlistDetails.put("uploaderName", extractor.getUploaderName());
            } catch (final Exception e) {
                playlistDetails.put("uploaderName", "Unknown");
            }
            try {
                playlistDetails.put("uploaderAvatarUrl", FetchData.getBestImage(extractor.getThumbnails()).getUrl());
            } catch (final Exception e) {
                playlistDetails.put("uploaderAvatarUrl", null);
            }
            try {
                playlistDetails.put("uploaderUrl", extractor.getUploaderUrl());
            } catch (final Exception e) {
                playlistDetails.put("uploaderUrl", null);
            }
            playlistDetails.put("streamCount", String.valueOf(extractor.getStreamCount()));
            playlistDetails.put("baseUrl", extractor.getBaseUrl());
            playlistDetails.put("originalUrl", extractor.getOriginalUrl());
            playlistDetails.put("id", extractor.getId());
            playlistDetails.put("url", extractor.getUrl());

        }
        return playlistDetails;

    }

    static public Map<Integer, Map<String, String>> getPlaylistStreams(final String url)
            throws Exception {
        final PlaylistExtractor oldextractor = extractors.get(url);
        if (oldextractor == null) {
            extractors.put(url, YouTube.getPlaylistExtractor(url));
        }
        final PlaylistExtractor extractor = extractors.get(url);
        if (extractor != null) {
            extractor.fetchPage();
            currentPages.put(extractor.getId(), extractor.getInitialPage());
            final List<StreamInfoItem> playlistItems = extractor.getInitialPage().getItems();
            return _fetchResultsFromItems(playlistItems);
        }
        return new HashMap<>();

    }

    static public Map<Integer, Map<String, String>> getPlaylistStreamsNextPage(final String url)
            throws Exception {

        final PlaylistExtractor oldextractor = extractors.get(url);
        if (oldextractor == null) {
            extractors.put(url, YouTube.getPlaylistExtractor(url));
        }
        final PlaylistExtractor extractor = extractors.get(url);
        if (extractor != null) {
            final ListExtractor.InfoItemsPage<StreamInfoItem> currentPage = currentPages.get(extractor.getId());
            if (currentPage == null) {
                return getPlaylistStreams(url);
            } else {
                if (currentPage.hasNextPage()) {
                    final ListExtractor.InfoItemsPage<StreamInfoItem> nextPage = extractor
                            .getPage(currentPage.getNextPage());
                    currentPages.put(extractor.getId(), nextPage);
                    final List<StreamInfoItem> playlistItems = nextPage.getItems();
                    return _fetchResultsFromItems(playlistItems);
                } else {
                    return new HashMap<>();
                }
            }
        }

        return new HashMap<>();
    }


    static public Map<Integer, Map<String, String>> _fetchResultsFromItems(final List<StreamInfoItem> items) {
        final Map<Integer, Map<String, String>> itemsMap = new HashMap<>();
        for (int i = 0; i < items.size(); i++) {

            final StreamInfoItem item = items.get(i);
            final Map<String, String> itemMap = FetchData.fetchStreamInfoItem(item);

            itemsMap.put(i, itemMap);
        }
        return itemsMap;
    }

}
