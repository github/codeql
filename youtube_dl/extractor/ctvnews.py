# coding: utf-8
from __future__ import unicode_literals

import re

from .common import InfoExtractor
from ..utils import orderedSet


class CTVNewsIE(InfoExtractor):
    _VALID_URL = r'https?://(?:.+?\.)?ctvnews\.ca/(?:video\?(?:clip|playlist|bin)Id=|.*?)(?P<id>[0-9.]+)'
    _TESTS = [{
        'url': 'http://www.ctvnews.ca/video?clipId=901995',
        'md5': '9b8624ba66351a23e0b6e1391971f9af',
        'info_dict': {
            'id': '901995',
            'ext': 'flv',
            'title': 'Extended: \'That person cannot be me\' Johnson says',
            'description': 'md5:958dd3b4f5bbbf0ed4d045c790d89285',
            'timestamp': 1467286284,
            'upload_date': '20160630',
        }
    }, {
        'url': 'http://www.ctvnews.ca/video?playlistId=1.2966224',
        'info_dict':
        {
            'id': '1.2966224',
        },
        'playlist_mincount': 19,
    }, {
        'url': 'http://www.ctvnews.ca/video?binId=1.2876780',
        'info_dict':
        {
            'id': '1.2876780',
        },
        'playlist_mincount': 100,
    }, {
        'url': 'http://www.ctvnews.ca/1.810401',
        'only_matching': True,
    }, {
        'url': 'http://www.ctvnews.ca/canadiens-send-p-k-subban-to-nashville-in-blockbuster-trade-1.2967231',
        'only_matching': True,
    }, {
        'url': 'http://vancouverisland.ctvnews.ca/video?clipId=761241',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        page_id = self._match_id(url)

        def ninecninemedia_url_result(clip_id):
            return {
                '_type': 'url_transparent',
                'id': clip_id,
                'url': '9c9media:ctvnews_web:%s' % clip_id,
                'ie_key': 'NineCNineMedia',
            }

        if page_id.isdigit():
            return ninecninemedia_url_result(page_id)
        else:
            webpage = self._download_webpage('http://www.ctvnews.ca/%s' % page_id, page_id, query={
                'ot': 'example.AjaxPageLayout.ot',
                'maxItemsPerPage': 1000000,
            })
            entries = [ninecninemedia_url_result(clip_id) for clip_id in orderedSet(
                re.findall(r'clip\.id\s*=\s*(\d+);', webpage))]
            return self.playlist_result(entries, page_id)
