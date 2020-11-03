# coding: utf-8
from __future__ import unicode_literals

import re

from .common import InfoExtractor
from ..compat import (
    compat_urllib_parse_unquote,
    compat_urllib_parse_urlparse,
)
from ..utils import (
    ExtractorError,
    float_or_none,
    sanitized_Request,
    unescapeHTML,
    update_url_query,
    urlencode_postdata,
    USER_AGENTS,
)


class CeskaTelevizeIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?ceskatelevize\.cz/ivysilani/(?:[^/?#&]+/)*(?P<id>[^/#?]+)'
    _TESTS = [{
        'url': 'http://www.ceskatelevize.cz/ivysilani/ivysilani/10441294653-hyde-park-civilizace/214411058091220',
        'info_dict': {
            'id': '61924494877246241',
            'ext': 'mp4',
            'title': 'Hyde Park Civilizace: Život v Grónsku',
            'description': 'md5:3fec8f6bb497be5cdb0c9e8781076626',
            'thumbnail': r're:^https?://.*\.jpg',
            'duration': 3350,
        },
        'params': {
            # m3u8 download
            'skip_download': True,
        },
    }, {
        'url': 'http://www.ceskatelevize.cz/ivysilani/10441294653-hyde-park-civilizace/215411058090502/bonus/20641-bonus-01-en',
        'info_dict': {
            'id': '61924494877028507',
            'ext': 'mp4',
            'title': 'Hyde Park Civilizace: Bonus 01 - En',
            'description': 'English Subtittles',
            'thumbnail': r're:^https?://.*\.jpg',
            'duration': 81.3,
        },
        'params': {
            # m3u8 download
            'skip_download': True,
        },
    }, {
        # live stream
        'url': 'http://www.ceskatelevize.cz/ivysilani/zive/ct4/',
        'info_dict': {
            'id': 402,
            'ext': 'mp4',
            'title': r're:^ČT Sport \d{4}-\d{2}-\d{2} \d{2}:\d{2}$',
            'is_live': True,
        },
        'params': {
            # m3u8 download
            'skip_download': True,
        },
        'skip': 'Georestricted to Czech Republic',
    }, {
        'url': 'http://www.ceskatelevize.cz/ivysilani/embed/iFramePlayer.php?hash=d6a3e1370d2e4fa76296b90bad4dfc19673b641e&IDEC=217 562 22150/0004&channelID=1&width=100%25',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        playlist_id = self._match_id(url)

        webpage = self._download_webpage(url, playlist_id)

        NOT_AVAILABLE_STRING = 'This content is not available at your territory due to limited copyright.'
        if '%s</p>' % NOT_AVAILABLE_STRING in webpage:
            raise ExtractorError(NOT_AVAILABLE_STRING, expected=True)

        type_ = None
        episode_id = None

        playlist = self._parse_json(
            self._search_regex(
                r'getPlaylistUrl\(\[({.+?})\]', webpage, 'playlist',
                default='{}'), playlist_id)
        if playlist:
            type_ = playlist.get('type')
            episode_id = playlist.get('id')

        if not type_:
            type_ = self._html_search_regex(
                r'getPlaylistUrl\(\[\{"type":"(.+?)","id":".+?"\}\],',
                webpage, 'type')
        if not episode_id:
            episode_id = self._html_search_regex(
                r'getPlaylistUrl\(\[\{"type":".+?","id":"(.+?)"\}\],',
                webpage, 'episode_id')

        data = {
            'playlist[0][type]': type_,
            'playlist[0][id]': episode_id,
            'requestUrl': compat_urllib_parse_urlparse(url).path,
            'requestSource': 'iVysilani',
        }

        entries = []

        for user_agent in (None, USER_AGENTS['Safari']):
            req = sanitized_Request(
                'https://www.ceskatelevize.cz/ivysilani/ajax/get-client-playlist',
                data=urlencode_postdata(data))

            req.add_header('Content-type', 'application/x-www-form-urlencoded')
            req.add_header('x-addr', '127.0.0.1')
            req.add_header('X-Requested-With', 'XMLHttpRequest')
            if user_agent:
                req.add_header('User-Agent', user_agent)
            req.add_header('Referer', url)

            playlistpage = self._download_json(req, playlist_id, fatal=False)

            if not playlistpage:
                continue

            playlist_url = playlistpage['url']
            if playlist_url == 'error_region':
                raise ExtractorError(NOT_AVAILABLE_STRING, expected=True)

            req = sanitized_Request(compat_urllib_parse_unquote(playlist_url))
            req.add_header('Referer', url)

            playlist_title = self._og_search_title(webpage, default=None)
            playlist_description = self._og_search_description(webpage, default=None)

            playlist = self._download_json(req, playlist_id, fatal=False)
            if not playlist:
                continue

            playlist = playlist.get('playlist')
            if not isinstance(playlist, list):
                continue

            playlist_len = len(playlist)

            for num, item in enumerate(playlist):
                is_live = item.get('type') == 'LIVE'
                formats = []
                for format_id, stream_url in item.get('streamUrls', {}).items():
                    if 'drmOnly=true' in stream_url:
                        continue
                    if 'playerType=flash' in stream_url:
                        stream_formats = self._extract_m3u8_formats(
                            stream_url, playlist_id, 'mp4', 'm3u8_native',
                            m3u8_id='hls-%s' % format_id, fatal=False)
                    else:
                        stream_formats = self._extract_mpd_formats(
                            stream_url, playlist_id,
                            mpd_id='dash-%s' % format_id, fatal=False)
                    # See https://github.com/ytdl-org/youtube-dl/issues/12119#issuecomment-280037031
                    if format_id == 'audioDescription':
                        for f in stream_formats:
                            f['source_preference'] = -10
                    formats.extend(stream_formats)

                if user_agent and len(entries) == playlist_len:
                    entries[num]['formats'].extend(formats)
                    continue

                item_id = item.get('id') or item['assetId']
                title = item['title']

                duration = float_or_none(item.get('duration'))
                thumbnail = item.get('previewImageUrl')

                subtitles = {}
                if item.get('type') == 'VOD':
                    subs = item.get('subtitles')
                    if subs:
                        subtitles = self.extract_subtitles(episode_id, subs)

                if playlist_len == 1:
                    final_title = playlist_title or title
                    if is_live:
                        final_title = self._live_title(final_title)
                else:
                    final_title = '%s (%s)' % (playlist_title, title)

                entries.append({
                    'id': item_id,
                    'title': final_title,
                    'description': playlist_description if playlist_len == 1 else None,
                    'thumbnail': thumbnail,
                    'duration': duration,
                    'formats': formats,
                    'subtitles': subtitles,
                    'is_live': is_live,
                })

        for e in entries:
            self._sort_formats(e['formats'])

        return self.playlist_result(entries, playlist_id, playlist_title, playlist_description)

    def _get_subtitles(self, episode_id, subs):
        original_subtitles = self._download_webpage(
            subs[0]['url'], episode_id, 'Downloading subtitles')
        srt_subs = self._fix_subtitles(original_subtitles)
        return {
            'cs': [{
                'ext': 'srt',
                'data': srt_subs,
            }]
        }

    @staticmethod
    def _fix_subtitles(subtitles):
        """ Convert millisecond-based subtitles to SRT """

        def _msectotimecode(msec):
            """ Helper utility to convert milliseconds to timecode """
            components = []
            for divider in [1000, 60, 60, 100]:
                components.append(msec % divider)
                msec //= divider
            return '{3:02}:{2:02}:{1:02},{0:03}'.format(*components)

        def _fix_subtitle(subtitle):
            for line in subtitle.splitlines():
                m = re.match(r'^\s*([0-9]+);\s*([0-9]+)\s+([0-9]+)\s*$', line)
                if m:
                    yield m.group(1)
                    start, stop = (_msectotimecode(int(t)) for t in m.groups()[1:])
                    yield '{0} --> {1}'.format(start, stop)
                else:
                    yield line

        return '\r\n'.join(_fix_subtitle(subtitles))


class CeskaTelevizePoradyIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?ceskatelevize\.cz/porady/(?:[^/?#&]+/)*(?P<id>[^/#?]+)'
    _TESTS = [{
        # video with 18+ caution trailer
        'url': 'http://www.ceskatelevize.cz/porady/10520528904-queer/215562210900007-bogotart/',
        'info_dict': {
            'id': '215562210900007-bogotart',
            'title': 'Queer: Bogotart',
            'description': 'Alternativní průvodce současným queer světem',
        },
        'playlist': [{
            'info_dict': {
                'id': '61924494876844842',
                'ext': 'mp4',
                'title': 'Queer: Bogotart (Varování 18+)',
                'duration': 10.2,
            },
        }, {
            'info_dict': {
                'id': '61924494877068022',
                'ext': 'mp4',
                'title': 'Queer: Bogotart (Queer)',
                'thumbnail': r're:^https?://.*\.jpg',
                'duration': 1558.3,
            },
        }],
        'params': {
            # m3u8 download
            'skip_download': True,
        },
    }, {
        # iframe embed
        'url': 'http://www.ceskatelevize.cz/porady/10614999031-neviditelni/21251212048/',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        video_id = self._match_id(url)

        webpage = self._download_webpage(url, video_id)

        data_url = update_url_query(unescapeHTML(self._search_regex(
            (r'<span[^>]*\bdata-url=(["\'])(?P<url>(?:(?!\1).)+)\1',
             r'<iframe[^>]+\bsrc=(["\'])(?P<url>(?:https?:)?//(?:www\.)?ceskatelevize\.cz/ivysilani/embed/iFramePlayer\.php.*?)\1'),
            webpage, 'iframe player url', group='url')), query={
                'autoStart': 'true',
        })

        return self.url_result(data_url, ie=CeskaTelevizeIE.ie_key())
