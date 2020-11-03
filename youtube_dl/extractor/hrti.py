# coding: utf-8
from __future__ import unicode_literals

import json
import re

from .common import InfoExtractor
from ..compat import compat_HTTPError
from ..utils import (
    clean_html,
    ExtractorError,
    int_or_none,
    parse_age_limit,
    sanitized_Request,
    try_get,
)


class HRTiBaseIE(InfoExtractor):
    """
        Base Information Extractor for Croatian Radiotelevision
        video on demand site https://hrti.hrt.hr
        Reverse engineered from the JavaScript app in app.min.js
    """
    _NETRC_MACHINE = 'hrti'

    _APP_LANGUAGE = 'hr'
    _APP_VERSION = '1.1'
    _APP_PUBLICATION_ID = 'all_in_one'
    _API_URL = 'http://clientapi.hrt.hr/client_api.php/config/identify/format/json'

    def _initialize_api(self):
        init_data = {
            'application_publication_id': self._APP_PUBLICATION_ID
        }

        uuid = self._download_json(
            self._API_URL, None, note='Downloading uuid',
            errnote='Unable to download uuid',
            data=json.dumps(init_data).encode('utf-8'))['uuid']

        app_data = {
            'uuid': uuid,
            'application_publication_id': self._APP_PUBLICATION_ID,
            'application_version': self._APP_VERSION
        }

        req = sanitized_Request(self._API_URL, data=json.dumps(app_data).encode('utf-8'))
        req.get_method = lambda: 'PUT'

        resources = self._download_json(
            req, None, note='Downloading session information',
            errnote='Unable to download session information')

        self._session_id = resources['session_id']

        modules = resources['modules']

        self._search_url = modules['vod_catalog']['resources']['search']['uri'].format(
            language=self._APP_LANGUAGE,
            application_id=self._APP_PUBLICATION_ID)

        self._login_url = (modules['user']['resources']['login']['uri']
                           + '/format/json').format(session_id=self._session_id)

        self._logout_url = modules['user']['resources']['logout']['uri']

    def _login(self):
        username, password = self._get_login_info()
        # TODO: figure out authentication with cookies
        if username is None or password is None:
            self.raise_login_required()

        auth_data = {
            'username': username,
            'password': password,
        }

        try:
            auth_info = self._download_json(
                self._login_url, None, note='Logging in', errnote='Unable to log in',
                data=json.dumps(auth_data).encode('utf-8'))
        except ExtractorError as e:
            if isinstance(e.cause, compat_HTTPError) and e.cause.code == 406:
                auth_info = self._parse_json(e.cause.read().encode('utf-8'), None)
            else:
                raise

        error_message = auth_info.get('error', {}).get('message')
        if error_message:
            raise ExtractorError(
                '%s said: %s' % (self.IE_NAME, error_message),
                expected=True)

        self._token = auth_info['secure_streaming_token']

    def _real_initialize(self):
        self._initialize_api()
        self._login()


class HRTiIE(HRTiBaseIE):
    _VALID_URL = r'''(?x)
                        (?:
                            hrti:(?P<short_id>[0-9]+)|
                            https?://
                                hrti\.hrt\.hr/(?:\#/)?video/show/(?P<id>[0-9]+)/(?P<display_id>[^/]+)?
                        )
                    '''
    _TESTS = [{
        'url': 'https://hrti.hrt.hr/#/video/show/2181385/republika-dokumentarna-serija-16-hd',
        'info_dict': {
            'id': '2181385',
            'display_id': 'republika-dokumentarna-serija-16-hd',
            'ext': 'mp4',
            'title': 'REPUBLIKA, dokumentarna serija (1/6) (HD)',
            'description': 'md5:48af85f620e8e0e1df4096270568544f',
            'duration': 2922,
            'view_count': int,
            'average_rating': int,
            'episode_number': int,
            'season_number': int,
            'age_limit': 12,
        },
        'skip': 'Requires account credentials',
    }, {
        'url': 'https://hrti.hrt.hr/#/video/show/2181385/',
        'only_matching': True,
    }, {
        'url': 'hrti:2181385',
        'only_matching': True,
    }, {
        'url': 'https://hrti.hrt.hr/video/show/3873068/cuvar-dvorca-dramska-serija-14',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        mobj = re.match(self._VALID_URL, url)
        video_id = mobj.group('short_id') or mobj.group('id')
        display_id = mobj.group('display_id') or video_id

        video = self._download_json(
            '%s/video_id/%s/format/json' % (self._search_url, video_id),
            display_id, 'Downloading video metadata JSON')['video'][0]

        title_info = video['title']
        title = title_info['title_long']

        movie = video['video_assets']['movie'][0]
        m3u8_url = movie['url'].format(TOKEN=self._token)
        formats = self._extract_m3u8_formats(
            m3u8_url, display_id, 'mp4', entry_protocol='m3u8_native',
            m3u8_id='hls')
        self._sort_formats(formats)

        description = clean_html(title_info.get('summary_long'))
        age_limit = parse_age_limit(video.get('parental_control', {}).get('rating'))
        view_count = int_or_none(video.get('views'))
        average_rating = int_or_none(video.get('user_rating'))
        duration = int_or_none(movie.get('duration'))

        return {
            'id': video_id,
            'display_id': display_id,
            'title': title,
            'description': description,
            'duration': duration,
            'view_count': view_count,
            'average_rating': average_rating,
            'age_limit': age_limit,
            'formats': formats,
        }


class HRTiPlaylistIE(HRTiBaseIE):
    _VALID_URL = r'https?://hrti\.hrt\.hr/(?:#/)?video/list/category/(?P<id>[0-9]+)/(?P<display_id>[^/]+)?'
    _TESTS = [{
        'url': 'https://hrti.hrt.hr/#/video/list/category/212/ekumena',
        'info_dict': {
            'id': '212',
            'title': 'ekumena',
        },
        'playlist_mincount': 8,
        'skip': 'Requires account credentials',
    }, {
        'url': 'https://hrti.hrt.hr/#/video/list/category/212/',
        'only_matching': True,
    }, {
        'url': 'https://hrti.hrt.hr/video/list/category/212/ekumena',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        mobj = re.match(self._VALID_URL, url)
        category_id = mobj.group('id')
        display_id = mobj.group('display_id') or category_id

        response = self._download_json(
            '%s/category_id/%s/format/json' % (self._search_url, category_id),
            display_id, 'Downloading video metadata JSON')

        video_ids = try_get(
            response, lambda x: x['video_listings'][0]['alternatives'][0]['list'],
            list) or [video['id'] for video in response.get('videos', []) if video.get('id')]

        entries = [self.url_result('hrti:%s' % video_id) for video_id in video_ids]

        return self.playlist_result(entries, category_id, display_id)
