package com.artxdev.newpipeextractor_dart.youtube;

import org.schabi.newpipe.extractor.exceptions.ParsingException;
import org.schabi.newpipe.extractor.services.youtube.linkHandler.YoutubeChannelLinkHandlerFactory;
import org.schabi.newpipe.extractor.services.youtube.linkHandler.YoutubePlaylistLinkHandlerFactory;
import org.schabi.newpipe.extractor.services.youtube.linkHandler.YoutubeStreamLinkHandlerFactory;

public class YoutubeLinkHandler {

    static public String getIdFromStreamUrl(final String url) {
        String parsedUrl = null;
        final YoutubeStreamLinkHandlerFactory streamLinkHandler =
                YoutubeStreamLinkHandlerFactory.getInstance();
        try {
            parsedUrl = streamLinkHandler.fromUrl(url).getId();
        } catch (final ParsingException ignored) {
        }
        return parsedUrl;
    }

    static public String getIdFromPlaylistUrl(final String url) {
        String parsedUrl = null;
        final YoutubePlaylistLinkHandlerFactory playlistLinkHandler =
                YoutubePlaylistLinkHandlerFactory.getInstance();
        try {
            parsedUrl = playlistLinkHandler.fromUrl(url).getId();
        } catch (final ParsingException ignored) {
        }
        return parsedUrl;
    }

    static public String getIdFromChannelUrl(final String url) {
        String parsedUrl = null;
        final YoutubeChannelLinkHandlerFactory channelLinkHandler =
                YoutubeChannelLinkHandlerFactory.getInstance();
        try {
            parsedUrl = channelLinkHandler.fromUrl(url).getId();
        } catch (final ParsingException ignored) {
        }
        return parsedUrl;
    }

}
