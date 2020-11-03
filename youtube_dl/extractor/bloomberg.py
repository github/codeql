# coding: utf-8
from __future__ import unicode_literals

import re

from .common import InfoExtractor


class BloombergIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?bloomberg\.com/(?:[^/]+/)*(?P<id>[^/?#]+)'

    _TESTS = [{
        'url': 'http://www.bloomberg.com/news/videos/b/aaeae121-5949-481e-a1ce-4562db6f5df2',
        # The md5 checksum changes
        'info_dict': {
            'id': 'qurhIVlJSB6hzkVi229d8g',
            'ext': 'flv',
            'title': 'Shah\'s Presentation on Foreign-Exchange Strategies',
            'description': 'md5:a8ba0302912d03d246979735c17d2761',
        },
        'params': {
            'format': 'best[format_id^=hds]',
        },
    }, {
        # video ID in BPlayer(...)
        'url': 'http://www.bloomberg.com/features/2016-hello-world-new-zealand/',
        'info_dict': {
            'id': '938c7e72-3f25-4ddb-8b85-a9be731baa74',
            'ext': 'flv',
            'title': 'Meet the Real-Life Tech Wizards of Middle Earth',
            'description': 'Hello World, Episode 1: New Zealand’s freaky AI babies, robot exoskeletons, and a virtual you.',
        },
        'params': {
            'format': 'best[format_id^=hds]',
        },
    }, {
        # data-bmmrid=
        'url': 'https://www.bloomberg.com/politics/articles/2017-02-08/le-pen-aide-briefed-french-central-banker-on-plan-to-print-money',
        'only_matching': True,
    }, {
        'url': 'http://www.bloomberg.com/news/articles/2015-11-12/five-strange-things-that-have-been-happening-in-financial-markets',
        'only_matching': True,
    }, {
        'url': 'http://www.bloomberg.com/politics/videos/2015-11-25/karl-rove-on-jeb-bush-s-struggles-stopping-trump',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        name = self._match_id(url)
        webpage = self._download_webpage(url, name)
        video_id = self._search_regex(
            (r'["\']bmmrId["\']\s*:\s*(["\'])(?P<id>(?:(?!\1).)+)\1',
             r'videoId\s*:\s*(["\'])(?P<id>(?:(?!\1).)+)\1',
             r'data-bmmrid=(["\'])(?P<id>(?:(?!\1).)+)\1'),
            webpage, 'id', group='id', default=None)
        if not video_id:
            bplayer_data = self._parse_json(self._search_regex(
                r'BPlayer\(null,\s*({[^;]+})\);', webpage, 'id'), name)
            video_id = bplayer_data['id']
        title = re.sub(': Video$', '', self._og_search_title(webpage))

        embed_info = self._download_json(
            'http://www.bloomberg.com/api/embed?id=%s' % video_id, video_id)
        formats = []
        for stream in embed_info['streams']:
            stream_url = stream.get('url')
            if not stream_url:
                continue
            if stream['muxing_format'] == 'TS':
                formats.extend(self._extract_m3u8_formats(
                    stream_url, video_id, 'mp4', m3u8_id='hls', fatal=False))
            else:
                formats.extend(self._extract_f4m_formats(
                    stream_url, video_id, f4m_id='hds', fatal=False))
        self._sort_formats(formats)

        return {
            'id': video_id,
            'title': title,
            'formats': formats,
            'description': self._og_search_description(webpage),
            'thumbnail': self._og_search_thumbnail(webpage),
        }
