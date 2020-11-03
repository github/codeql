from __future__ import unicode_literals

from .common import InfoExtractor


class EngadgetIE(InfoExtractor):
    _VALID_URL = r'https?://(?:www\.)?engadget\.com/video/(?P<id>[^/?#]+)'

    _TESTS = [{
        # video with 5min ID
        'url': 'http://www.engadget.com/video/518153925/',
        'md5': 'c6820d4828a5064447a4d9fc73f312c9',
        'info_dict': {
            'id': '518153925',
            'ext': 'mp4',
            'title': 'Samsung Galaxy Tab Pro 8.4 Review',
        },
        'add_ie': ['FiveMin'],
    }, {
        # video with vidible ID
        'url': 'https://www.engadget.com/video/57a28462134aa15a39f0421a/',
        'only_matching': True,
    }]

    def _real_extract(self, url):
        video_id = self._match_id(url)
        return self.url_result('aol-video:%s' % video_id)
