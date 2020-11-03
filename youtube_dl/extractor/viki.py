# coding: utf-8
from __future__ import unicode_literals

import hashlib
import hmac
import itertools
import json
import re
import time

from .common import InfoExtractor
from ..utils import (
    ExtractorError,
    int_or_none,
    parse_age_limit,
    parse_iso8601,
    sanitized_Request,
)


class VikiBaseIE(InfoExtractor):
    _VALID_URL_BASE = r'https?://(?:www\.)?viki\.(?:com|net|mx|jp|fr)/'
    _API_QUERY_TEMPLATE = '/v4/%sapp=%s&t=%s&site=www.viki.com'
    _API_URL_TEMPLATE = 'https://api.viki.io%s&sig=%s'

    _APP = '100005a'
    _APP_VERSION = '2.2.5.1428709186'
    _APP_SECRET = 'MM_d*yP@`&1@]@!AVrXf_o-HVEnoTnm$O-ti4[G~$JDI/Dc-&piU&z&5.;:}95=Iad'

    _GEO_BYPASS = False
    _NETRC_MACHINE = 'viki'

    _token = None

    _ERRORS = {
        'geo': 'Sorry, this content is not available in your region.',
        'upcoming': 'Sorry, this content is not yet available.',
        # 'paywall': 'paywall',
    }

    def _prepare_call(self, path, timestamp=None, post_data=None):
        path += '?' if '?' not in path else '&'
        if not timestamp:
            timestamp = int(time.time())
        query = self._API_QUERY_TEMPLATE % (path, self._APP, timestamp)
        if self._token:
            query += '&token=%s' % self._token
        sig = hmac.new(
            self._APP_SECRET.encode('ascii'),
            query.encode('ascii'),
            hashlib.sha1
        ).hexdigest()
        url = self._API_URL_TEMPLATE % (query, sig)
        return sanitized_Request(
            url, json.dumps(post_data).encode('utf-8')) if post_data else url

    def _call_api(self, path, video_id, note, timestamp=None, post_data=None):
        resp = self._download_json(
            self._prepare_call(path, timestamp, post_data), video_id, note)

        error = resp.get('error')
        if error:
            if error == 'invalid timestamp':
                resp = self._download_json(
                    self._prepare_call(path, int(resp['current_timestamp']), post_data),
                    video_id, '%s (retry)' % note)
                error = resp.get('error')
            if error:
                self._raise_error(resp['error'])

        return resp

    def _raise_error(self, error):
        raise ExtractorError(
            '%s returned error: %s' % (self.IE_NAME, error),
            expected=True)

    def _check_errors(self, data):
        for reason, status in data.get('blocking', {}).items():
            if status and reason in self._ERRORS:
                message = self._ERRORS[reason]
                if reason == 'geo':
                    self.raise_geo_restricted(msg=message)
                raise ExtractorError('%s said: %s' % (
                    self.IE_NAME, message), expected=True)

    def _real_initialize(self):
        self._login()

    def _login(self):
        username, password = self._get_login_info()
        if username is None:
            return

        login_form = {
            'login_id': username,
            'password': password,
        }

        login = self._call_api(
            'sessions.json', None,
            'Logging in', post_data=login_form)

        self._token = login.get('token')
        if not self._token:
            self.report_warning('Unable to get session token, login has probably failed')

    @staticmethod
    def dict_selection(dict_obj, preferred_key, allow_fallback=True):
        if preferred_key in dict_obj:
            return dict_obj.get(preferred_key)

        if not allow_fallback:
            return

        filtered_dict = list(filter(None, [dict_obj.get(k) for k in dict_obj.keys()]))
        return filtered_dict[0] if filtered_dict else None


class VikiIE(VikiBaseIE):
    IE_NAME = 'viki'
    _VALID_URL = r'%s(?:videos|player)/(?P<id>[0-9]+v)' % VikiBaseIE._VALID_URL_BASE
    _TESTS = [{
        'url': 'http://www.viki.com/videos/1023585v-heirs-episode-14',
        'info_dict': {
            'id': '1023585v',
            'ext': 'mp4',
            'title': 'Heirs Episode 14',
            'uploader': 'SBS',
            'description': 'md5:c4b17b9626dd4b143dcc4d855ba3474e',
            'upload_date': '20131121',
            'age_limit': 13,
        },
        'skip': 'Blocked in the US',
    }, {
        # clip
        'url': 'http://www.viki.com/videos/1067139v-the-avengers-age-of-ultron-press-conference',
        'md5': '86c0b5dbd4d83a6611a79987cc7a1989',
        'info_dict': {
            'id': '1067139v',
            'ext': 'mp4',
            'title': "'The Avengers: Age of Ultron' Press Conference",
            'description': 'md5:d70b2f9428f5488321bfe1db10d612ea',
            'duration': 352,
            'timestamp': 1430380829,
            'upload_date': '20150430',
            'uploader': 'Arirang TV',
            'like_count': int,
            'age_limit': 0,
        }
    }, {
        'url': 'http://www.viki.com/videos/1048879v-ankhon-dekhi',
        'info_dict': {
            'id': '1048879v',
            'ext': 'mp4',
            'title': 'Ankhon Dekhi',
            'duration': 6512,
            'timestamp': 1408532356,
            'upload_date': '20140820',
            'uploader': 'Spuul',
            'like_count': int,
            'age_limit': 13,
        },
        'skip': 'Blocked in the US',
    }, {
        # episode
        'url': 'http://www.viki.com/videos/44699v-boys-over-flowers-episode-1',
        'md5': '5fa476a902e902783ac7a4d615cdbc7a',
        'info_dict': {
            'id': '44699v',
            'ext': 'mp4',
            'title': 'Boys Over Flowers - Episode 1',
            'description': 'md5:b89cf50038b480b88b5b3c93589a9076',
            'duration': 4204,
            'timestamp': 1270496524,
            'upload_date': '20100405',
            'uploader': 'group8',
            'like_count': int,
            'age_limit': 13,
        }
    }, {
        # youtube external
        'url': 'http://www.viki.com/videos/50562v-poor-nastya-complete-episode-1',
        'md5': '63f8600c1da6f01b7640eee7eca4f1da',
        'info_dict': {
            'id': '50562v',
            'ext': 'webm',
            'title': 'Poor Nastya [COMPLETE] - Episode 1',
            'description': '',
            'duration': 606,
            'timestamp': 1274949505,
            'upload_date': '20101213',
            'uploader': 'ad14065n',
            'uploader_id': 'ad14065n',
            'like_count': int,
            'age_limit': 13,
        }
    }, {
        'url': 'http://www.viki.com/player/44699v',
        'only_matching': True,
    }, {
        # non-English description
        'url': 'http://www.viki.com/videos/158036v-love-in-magic',
        'md5': '1713ae35df5a521b31f6dc40730e7c9c',
        'info_dict': {
            'id': '158036v',
            'ext': 'mp4',
            'uploader': 'I Planet Entertainment',
            'upload_date': '20111122',
            'timestamp': 1321985454,
            'description': 'md5:44b1e46619df3a072294645c770cef36',
            'title': 'Love In Magic',
            'age_limit': 13,
        },
    }]

    def _real_extract(self, url):
        video_id = self._match_id(url)

        video = self._call_api(
            'videos/%s.json' % video_id, video_id, 'Downloading video JSON')

        self._check_errors(video)

        title = self.dict_selection(video.get('titles', {}), 'en', allow_fallback=False)
        if not title:
            title = 'Episode %d' % video.get('number') if video.get('type') == 'episode' else video.get('id') or video_id
            container_titles = video.get('container', {}).get('titles', {})
            container_title = self.dict_selection(container_titles, 'en')
            title = '%s - %s' % (container_title, title)

        description = self.dict_selection(video.get('descriptions', {}), 'en')

        duration = int_or_none(video.get('duration'))
        timestamp = parse_iso8601(video.get('created_at'))
        uploader = video.get('author')
        like_count = int_or_none(video.get('likes', {}).get('count'))
        age_limit = parse_age_limit(video.get('rating'))

        thumbnails = []
        for thumbnail_id, thumbnail in video.get('images', {}).items():
            thumbnails.append({
                'id': thumbnail_id,
                'url': thumbnail.get('url'),
            })

        subtitles = {}
        for subtitle_lang, _ in video.get('subtitle_completions', {}).items():
            subtitles[subtitle_lang] = [{
                'ext': subtitles_format,
                'url': self._prepare_call(
                    'videos/%s/subtitles/%s.%s' % (video_id, subtitle_lang, subtitles_format)),
            } for subtitles_format in ('srt', 'vtt')]

        result = {
            'id': video_id,
            'title': title,
            'description': description,
            'duration': duration,
            'timestamp': timestamp,
            'uploader': uploader,
            'like_count': like_count,
            'age_limit': age_limit,
            'thumbnails': thumbnails,
            'subtitles': subtitles,
        }

        streams = self._call_api(
            'videos/%s/streams.json' % video_id, video_id,
            'Downloading video streams JSON')

        if 'external' in streams:
            result.update({
                '_type': 'url_transparent',
                'url': streams['external']['url'],
            })
            return result

        formats = []
        for format_id, stream_dict in streams.items():
            height = int_or_none(self._search_regex(
                r'^(\d+)[pP]$', format_id, 'height', default=None))
            for protocol, format_dict in stream_dict.items():
                # rtmps URLs does not seem to work
                if protocol == 'rtmps':
                    continue
                format_url = format_dict['url']
                if format_id == 'm3u8':
                    m3u8_formats = self._extract_m3u8_formats(
                        format_url, video_id, 'mp4',
                        entry_protocol='m3u8_native',
                        m3u8_id='m3u8-%s' % protocol, fatal=False)
                    # Despite CODECS metadata in m3u8 all video-only formats
                    # are actually video+audio
                    for f in m3u8_formats:
                        if f.get('acodec') == 'none' and f.get('vcodec') != 'none':
                            f['acodec'] = None
                    formats.extend(m3u8_formats)
                elif format_url.startswith('rtmp'):
                    mobj = re.search(
                        r'^(?P<url>rtmp://[^/]+/(?P<app>.+?))/(?P<playpath>mp4:.+)$',
                        format_url)
                    if not mobj:
                        continue
                    formats.append({
                        'format_id': 'rtmp-%s' % format_id,
                        'ext': 'flv',
                        'url': mobj.group('url'),
                        'play_path': mobj.group('playpath'),
                        'app': mobj.group('app'),
                        'page_url': url,
                    })
                else:
                    formats.append({
                        'url': format_url,
                        'format_id': '%s-%s' % (format_id, protocol),
                        'height': height,
                    })
        self._sort_formats(formats)

        result['formats'] = formats
        return result


class VikiChannelIE(VikiBaseIE):
    IE_NAME = 'viki:channel'
    _VALID_URL = r'%s(?:tv|news|movies|artists)/(?P<id>[0-9]+c)' % VikiBaseIE._VALID_URL_BASE
    _TESTS = [{
        'url': 'http://www.viki.com/tv/50c-boys-over-flowers',
        'info_dict': {
            'id': '50c',
            'title': 'Boys Over Flowers',
            'description': 'md5:ecd3cff47967fe193cff37c0bec52790',
        },
        'playlist_mincount': 71,
    }, {
        'url': 'http://www.viki.com/tv/1354c-poor-nastya-complete',
        'info_dict': {
            'id': '1354c',
            'title': 'Poor Nastya [COMPLETE]',
            'description': 'md5:05bf5471385aa8b21c18ad450e350525',
        },
        'playlist_count': 127,
    }, {
        'url': 'http://www.viki.com/news/24569c-showbiz-korea',
        'only_matching': True,
    }, {
        'url': 'http://www.viki.com/movies/22047c-pride-and-prejudice-2005',
        'only_matching': True,
    }, {
        'url': 'http://www.viki.com/artists/2141c-shinee',
        'only_matching': True,
    }]

    _PER_PAGE = 25

    def _real_extract(self, url):
        channel_id = self._match_id(url)

        channel = self._call_api(
            'containers/%s.json' % channel_id, channel_id,
            'Downloading channel JSON')

        self._check_errors(channel)

        title = self.dict_selection(channel['titles'], 'en')

        description = self.dict_selection(channel['descriptions'], 'en')

        entries = []
        for video_type in ('episodes', 'clips', 'movies'):
            for page_num in itertools.count(1):
                page = self._call_api(
                    'containers/%s/%s.json?per_page=%d&sort=number&direction=asc&with_paging=true&page=%d'
                    % (channel_id, video_type, self._PER_PAGE, page_num), channel_id,
                    'Downloading %s JSON page #%d' % (video_type, page_num))
                for video in page['response']:
                    video_id = video['id']
                    entries.append(self.url_result(
                        'https://www.viki.com/videos/%s' % video_id, 'Viki'))
                if not page['pagination']['next']:
                    break

        return self.playlist_result(entries, channel_id, title, description)
