# coding: utf-8
from __future__ import unicode_literals

import re
import time
import itertools

from .common import InfoExtractor
from .naver import NaverBaseIE
from ..compat import compat_str
from ..utils import (
    ExtractorError,
    merge_dicts,
    remove_start,
    try_get,
    urlencode_postdata,
)


class VLiveIE(NaverBaseIE):
    IE_NAME = 'vlive'
    _VALID_URL = r'https?://(?:(?:www|m)\.)?vlive\.tv/video/(?P<id>[0-9]+)'
    _NETRC_MACHINE = 'vlive'
    _TESTS = [{
        'url': 'http://www.vlive.tv/video/1326',
        'md5': 'cc7314812855ce56de70a06a27314983',
        'info_dict': {
            'id': '1326',
            'ext': 'mp4',
            'title': "[V LIVE] Girl's Day's Broadcast",
            'creator': "Girl's Day",
            'view_count': int,
            'uploader_id': 'muploader_a',
        },
    }, {
        'url': 'http://www.vlive.tv/video/16937',
        'info_dict': {
            'id': '16937',
            'ext': 'mp4',
            'title': '[V LIVE] 첸백시 걍방',
            'creator': 'EXO',
            'view_count': int,
            'subtitles': 'mincount:12',
            'uploader_id': 'muploader_j',
        },
        'params': {
            'skip_download': True,
        },
    }, {
        'url': 'https://www.vlive.tv/video/129100',
        'md5': 'ca2569453b79d66e5b919e5d308bff6b',
        'info_dict': {
            'id': '129100',
            'ext': 'mp4',
            'title': '[V LIVE] [BTS+] Run BTS! 2019 - EP.71 :: Behind the scene',
            'creator': 'BTS+',
            'view_count': int,
            'subtitles': 'mincount:10',
        },
        'skip': 'This video is only available for CH+ subscribers',
    }]

    @classmethod
    def suitable(cls, url):
        return False if VLivePlaylistIE.suitable(url) else super(VLiveIE, cls).suitable(url)

    def _real_initialize(self):
        self._login()

    def _login(self):
        email, password = self._get_login_info()
        if None in (email, password):
            return

        def is_logged_in():
            login_info = self._download_json(
                'https://www.vlive.tv/auth/loginInfo', None,
                note='Downloading login info',
                headers={'Referer': 'https://www.vlive.tv/home'})
            return try_get(
                login_info, lambda x: x['message']['login'], bool) or False

        LOGIN_URL = 'https://www.vlive.tv/auth/email/login'
        self._request_webpage(
            LOGIN_URL, None, note='Downloading login cookies')

        self._download_webpage(
            LOGIN_URL, None, note='Logging in',
            data=urlencode_postdata({'email': email, 'pwd': password}),
            headers={
                'Referer': LOGIN_URL,
                'Content-Type': 'application/x-www-form-urlencoded'
            })

        if not is_logged_in():
            raise ExtractorError('Unable to log in', expected=True)

    def _real_extract(self, url):
        video_id = self._match_id(url)

        webpage = self._download_webpage(
            'https://www.vlive.tv/video/%s' % video_id, video_id)

        VIDEO_PARAMS_RE = r'\bvlive\.video\.init\(([^)]+)'
        VIDEO_PARAMS_FIELD = 'video params'

        params = self._parse_json(self._search_regex(
            VIDEO_PARAMS_RE, webpage, VIDEO_PARAMS_FIELD, default=''), video_id,
            transform_source=lambda s: '[' + s + ']', fatal=False)

        if not params or len(params) < 7:
            params = self._search_regex(
                VIDEO_PARAMS_RE, webpage, VIDEO_PARAMS_FIELD)
            params = [p.strip(r'"') for p in re.split(r'\s*,\s*', params)]

        status, long_video_id, key = params[2], params[5], params[6]
        status = remove_start(status, 'PRODUCT_')

        if status in ('LIVE_ON_AIR', 'BIG_EVENT_ON_AIR'):
            return self._live(video_id, webpage)
        elif status in ('VOD_ON_AIR', 'BIG_EVENT_INTRO'):
            return self._replay(video_id, webpage, long_video_id, key)

        if status == 'LIVE_END':
            raise ExtractorError('Uploading for replay. Please wait...',
                                 expected=True)
        elif status == 'COMING_SOON':
            raise ExtractorError('Coming soon!', expected=True)
        elif status == 'CANCELED':
            raise ExtractorError('We are sorry, '
                                 'but the live broadcast has been canceled.',
                                 expected=True)
        elif status == 'ONLY_APP':
            raise ExtractorError('Unsupported video type', expected=True)
        else:
            raise ExtractorError('Unknown status %s' % status)

    def _get_common_fields(self, webpage):
        title = self._og_search_title(webpage)
        creator = self._html_search_regex(
            r'<div[^>]+class="info_area"[^>]*>\s*(?:<em[^>]*>.*?</em\s*>\s*)?<a\s+[^>]*>([^<]+)',
            webpage, 'creator', fatal=False)
        thumbnail = self._og_search_thumbnail(webpage)
        return {
            'title': title,
            'creator': creator,
            'thumbnail': thumbnail,
        }

    def _live(self, video_id, webpage):
        init_page = self._download_init_page(video_id)

        live_params = self._search_regex(
            r'"liveStreamInfo"\s*:\s*(".*"),',
            init_page, 'live stream info')
        live_params = self._parse_json(live_params, video_id)
        live_params = self._parse_json(live_params, video_id)

        formats = []
        for vid in live_params.get('resolutions', []):
            formats.extend(self._extract_m3u8_formats(
                vid['cdnUrl'], video_id, 'mp4',
                m3u8_id=vid.get('name'),
                fatal=False, live=True))
        self._sort_formats(formats)

        info = self._get_common_fields(webpage)
        info.update({
            'title': self._live_title(info['title']),
            'id': video_id,
            'formats': formats,
            'is_live': True,
        })
        return info

    def _replay(self, video_id, webpage, long_video_id, key):
        if '' in (long_video_id, key):
            init_page = self._download_init_page(video_id)
            video_info = self._parse_json(self._search_regex(
                (r'(?s)oVideoStatus\s*=\s*({.+?})\s*</script',
                 r'(?s)oVideoStatus\s*=\s*({.+})'), init_page, 'video info'),
                video_id)
            if video_info.get('status') == 'NEED_CHANNEL_PLUS':
                self.raise_login_required(
                    'This video is only available for CH+ subscribers')
            long_video_id, key = video_info['vid'], video_info['inkey']

        return merge_dicts(
            self._get_common_fields(webpage),
            self._extract_video_info(video_id, long_video_id, key))

    def _download_init_page(self, video_id):
        return self._download_webpage(
            'https://www.vlive.tv/video/init/view',
            video_id, note='Downloading live webpage',
            data=urlencode_postdata({'videoSeq': video_id}),
            headers={
                'Referer': 'https://www.vlive.tv/video/%s' % video_id,
                'Content-Type': 'application/x-www-form-urlencoded'
            })


class VLiveChannelIE(InfoExtractor):
    IE_NAME = 'vlive:channel'
    _VALID_URL = r'https?://channels\.vlive\.tv/(?P<id>[0-9A-Z]+)'
    _TEST = {
        'url': 'http://channels.vlive.tv/FCD4B',
        'info_dict': {
            'id': 'FCD4B',
            'title': 'MAMAMOO',
        },
        'playlist_mincount': 110
    }
    _APP_ID = '8c6cc7b45d2568fb668be6e05b6e5a3b'

    def _real_extract(self, url):
        channel_code = self._match_id(url)

        webpage = self._download_webpage(
            'http://channels.vlive.tv/%s/video' % channel_code, channel_code)

        app_id = None

        app_js_url = self._search_regex(
            r'<script[^>]+src=(["\'])(?P<url>http.+?/app\.js.*?)\1',
            webpage, 'app js', default=None, group='url')

        if app_js_url:
            app_js = self._download_webpage(
                app_js_url, channel_code, 'Downloading app JS', fatal=False)
            if app_js:
                app_id = self._search_regex(
                    r'Global\.VFAN_APP_ID\s*=\s*[\'"]([^\'"]+)[\'"]',
                    app_js, 'app id', default=None)

        app_id = app_id or self._APP_ID

        channel_info = self._download_json(
            'http://api.vfan.vlive.tv/vproxy/channelplus/decodeChannelCode',
            channel_code, note='Downloading decode channel code',
            query={
                'app_id': app_id,
                'channelCode': channel_code,
                '_': int(time.time())
            })

        channel_seq = channel_info['result']['channelSeq']
        channel_name = None
        entries = []

        for page_num in itertools.count(1):
            video_list = self._download_json(
                'http://api.vfan.vlive.tv/vproxy/channelplus/getChannelVideoList',
                channel_code, note='Downloading channel list page #%d' % page_num,
                query={
                    'app_id': app_id,
                    'channelSeq': channel_seq,
                    # Large values of maxNumOfRows (~300 or above) may cause
                    # empty responses (see [1]), e.g. this happens for [2] that
                    # has more than 300 videos.
                    # 1. https://github.com/ytdl-org/youtube-dl/issues/13830
                    # 2. http://channels.vlive.tv/EDBF.
                    'maxNumOfRows': 100,
                    '_': int(time.time()),
                    'pageNo': page_num
                }
            )

            if not channel_name:
                channel_name = try_get(
                    video_list,
                    lambda x: x['result']['channelInfo']['channelName'],
                    compat_str)

            videos = try_get(
                video_list, lambda x: x['result']['videoList'], list)
            if not videos:
                break

            for video in videos:
                video_id = video.get('videoSeq')
                if not video_id:
                    continue
                video_id = compat_str(video_id)
                entries.append(
                    self.url_result(
                        'http://www.vlive.tv/video/%s' % video_id,
                        ie=VLiveIE.ie_key(), video_id=video_id))

        return self.playlist_result(
            entries, channel_code, channel_name)


class VLivePlaylistIE(InfoExtractor):
    IE_NAME = 'vlive:playlist'
    _VALID_URL = r'https?://(?:(?:www|m)\.)?vlive\.tv/video/(?P<video_id>[0-9]+)/playlist/(?P<id>[0-9]+)'
    _VIDEO_URL_TEMPLATE = 'http://www.vlive.tv/video/%s'
    _TESTS = [{
        # regular working playlist
        'url': 'https://www.vlive.tv/video/117956/playlist/117963',
        'info_dict': {
            'id': '117963',
            'title': '아이돌룸(IDOL ROOM) 41회 - (여자)아이들'
        },
        'playlist_mincount': 10
    }, {
        # playlist with no playlistVideoSeqs
        'url': 'http://www.vlive.tv/video/22867/playlist/22912',
        'info_dict': {
            'id': '22867',
            'ext': 'mp4',
            'title': '[V LIVE] Valentine Day Message from MINA',
            'creator': 'TWICE',
            'view_count': int
        },
        'params': {
            'skip_download': True,
        }
    }]

    def _build_video_result(self, video_id, message):
        self.to_screen(message)
        return self.url_result(
            self._VIDEO_URL_TEMPLATE % video_id,
            ie=VLiveIE.ie_key(), video_id=video_id)

    def _real_extract(self, url):
        mobj = re.match(self._VALID_URL, url)
        video_id, playlist_id = mobj.group('video_id', 'id')

        if self._downloader.params.get('noplaylist'):
            return self._build_video_result(
                video_id,
                'Downloading just video %s because of --no-playlist'
                % video_id)

        self.to_screen(
            'Downloading playlist %s - add --no-playlist to just download video'
            % playlist_id)

        webpage = self._download_webpage(
            'http://www.vlive.tv/video/%s/playlist/%s'
            % (video_id, playlist_id), playlist_id)

        raw_item_ids = self._search_regex(
            r'playlistVideoSeqs\s*=\s*(\[[^]]+\])', webpage,
            'playlist video seqs', default=None, fatal=False)

        if not raw_item_ids:
            return self._build_video_result(
                video_id,
                'Downloading just video %s because no playlist was found'
                % video_id)

        item_ids = self._parse_json(raw_item_ids, playlist_id)

        entries = [
            self.url_result(
                self._VIDEO_URL_TEMPLATE % item_id, ie=VLiveIE.ie_key(),
                video_id=compat_str(item_id))
            for item_id in item_ids]

        playlist_name = self._html_search_regex(
            r'<div[^>]+class="[^"]*multicam_playlist[^>]*>\s*<h3[^>]+>([^<]+)',
            webpage, 'playlist title', fatal=False)

        return self.playlist_result(entries, playlist_id, playlist_name)
