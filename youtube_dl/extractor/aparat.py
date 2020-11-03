# coding: utf-8
from __future__ import unicode_literals

from .common import InfoExtractor
from ..utils import (
    int_or_none,
    merge_dicts,
    mimetype2ext,
    url_or_none,
)


class AparatIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?aparat\.com/(?:v/|video/video/embed/videohash/)(?P<id>[a-zA-Z0-9]+)'

    _TESTS = [{
        'url': 'http://www.aparat.com/v/wP8On',
        'md5': '131aca2e14fe7c4dcb3c4877ba300c89',
        'info_dict': {
            'id': 'wP8On',
            'ext': 'mp4',
            'title': 'تیم گلکسی 11 - زومیت',
            'description': 'md5:096bdabcdcc4569f2b8a5e903a3b3028',
            'duration': 231,
            'timestamp': 1387394859,
            'upload_date': '20131218',
            'view_count': int,
        },
    }, {
        # multiple formats
        'url': 'https://www.aparat.com/v/8dflw/',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        video_id = self._match_id(url)

        # Provides more metadata
        webpage = self._download_webpage(url, video_id, fatal=False)

        if not webpage:
            # Note: There is an easier-to-parse configuration at
            # http://www.aparat.com/video/video/config/videohash/%video_id
            # but the URL in there does not work
            webpage = self._download_webpage(
                'http://www.aparat.com/video/video/embed/vt/frame/showvideo/yes/videohash/' + video_id,
                video_id)

        options = self._parse_json(
            self._search_regex(
                r'options\s*=\s*JSON\.parse\(\s*(["\'])(?P<value>(?:(?!\1).)+)\1\s*\)',
                webpage, 'options', group='value'),
            video_id)

        player = options['plugins']['sabaPlayerPlugin']

        formats = []
        for sources in player['multiSRC']:
            for item in sources:
                if not isinstance(item, dict):
                    continue
                file_url = url_or_none(item.get('src'))
                if not file_url:
                    continue
                item_type = item.get('type')
                if item_type == 'application/vnd.apple.mpegurl':
                    formats.extend(self._extract_m3u8_formats(
                        file_url, video_id, 'mp4',
                        entry_protocol='m3u8_native', m3u8_id='hls',
                        fatal=False))
                else:
                    ext = mimetype2ext(item.get('type'))
                    label = item.get('label')
                    formats.append({
                        'url': file_url,
                        'ext': ext,
                        'format_id': 'http-%s' % (label or ext),
                        'height': int_or_none(self._search_regex(
                            r'(\d+)[pP]', label or '', 'height',
                            default=None)),
                    })
        self._sort_formats(
            formats, field_preference=('height', 'width', 'tbr', 'format_id'))

        info = self._search_json_ld(webpage, video_id, default={})

        if not info.get('title'):
            info['title'] = player['title']

        return merge_dicts(info, {
            'id': video_id,
            'thumbnail': url_or_none(options.get('poster')),
            'duration': int_or_none(player.get('duration')),
            'formats': formats,
        })
