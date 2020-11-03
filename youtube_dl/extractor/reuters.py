# coding: utf-8
from __future__ import unicode_literals

import re

from .common import InfoExtractor
from ..utils import (
    js_to_json,
    int_or_none,
    unescapeHTML,
)


class ReutersIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?reuters\.com/.*?\?.*?videoId=(?P<id>[0-9]+)'
    _TEST = {
        'url': 'http://www.reuters.com/video/2016/05/20/san-francisco-police-chief-resigns?videoId=368575562',
        'md5': '8015113643a0b12838f160b0b81cc2ee',
        'info_dict': {
            'id': '368575562',
            'ext': 'mp4',
            'title': 'San Francisco police chief resigns',
        }
    }

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(
            'http://www.reuters.com/assets/iframe/yovideo?videoId=%s' % video_id, video_id)
        video_data = js_to_json(self._search_regex(
            r'(?s)Reuters\.yovideo\.drawPlayer\(({.*?})\);',
            webpage, 'video data'))

        def get_json_value(key, fatal=False):
            return self._search_regex(r'"%s"\s*:\s*"([^"]+)"' % key, video_data, key, fatal=fatal)

        title = unescapeHTML(get_json_value('title', fatal=True))
        mmid, fid = re.search(r',/(\d+)\?f=(\d+)', get_json_value('flv', fatal=True)).groups()

        mas_data = self._download_json(
            'http://mas-e.cds1.yospace.com/mas/%s/%s?trans=json' % (mmid, fid),
            video_id, transform_source=js_to_json)
        formats = []
        for f in mas_data:
            f_url = f.get('url')
            if not f_url:
                continue
            method = f.get('method')
            if method == 'hls':
                formats.extend(self._extract_m3u8_formats(
                    f_url, video_id, 'mp4', 'm3u8_native', m3u8_id='hls', fatal=False))
            else:
                container = f.get('container')
                ext = '3gp' if method == 'mobile' else container
                formats.append({
                    'format_id': ext,
                    'url': f_url,
                    'ext': ext,
                    'container': container if method != 'mobile' else None,
                })
        self._sort_formats(formats)

        return {
            'id': video_id,
            'title': title,
            'thumbnail': get_json_value('thumb'),
            'duration': int_or_none(get_json_value('seconds')),
            'formats': formats,
        }
